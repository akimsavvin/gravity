package jwt

import (
	"fmt"
	"github.com/golang-jwt/jwt/v5"
	"github.com/gookit/goutil"
	"strings"
)

type Helper struct {
	claims       jwt.MapClaims
	realmRoles   []string
	accountRoles []string
	scopes       []string
}

func NewHelper(claims jwt.MapClaims) *Helper {
	return &Helper{
		claims:       claims,
		realmRoles:   parseRealmRoles(claims),
		accountRoles: parseAccountRoles(claims),
		scopes:       parseScopes(claims),
	}
}

func (h *Helper) GetUserId() (string, error) {
	return h.claims.GetSubject()
}

func (h *Helper) IsUserInRealmRole(role string) bool {
	return goutil.Contains(h.realmRoles, role)
}

func (h *Helper) TokenHasScope(scope string) bool {
	return goutil.Contains(h.scopes, scope)
}

func parseRealmRoles(claims jwt.MapClaims) []string {
	var realmRoles []string = make([]string, 0)
	if claim, ok := claims["realm_access"]; ok {
		if roles, ok := claim.(map[string]interface{})["roles"]; ok {
			for _, role := range roles.([]interface{}) {
				realmRoles = append(realmRoles, role.(string))
			}
		}
	}
	return realmRoles
}

func parseAccountRoles(claims jwt.MapClaims) []string {
	var accountRoles []string = make([]string, 0)
	if claim, ok := claims["resource_access"]; ok {
		if acc, ok := claim.(map[string]interface{})["account"]; ok {
			if roles, ok := acc.(map[string]interface{})["roles"]; ok {
				for _, role := range roles.([]interface{}) {
					accountRoles = append(accountRoles, role.(string))
				}
			}
		}
	}
	return accountRoles
}

func parseScopes(claims jwt.MapClaims) []string {
	scopeStr, err := parseString(claims, "scope")
	if err != nil {
		return make([]string, 0)
	}
	scopes := strings.Split(scopeStr, " ")
	return scopes
}

func parseString(claims jwt.MapClaims, key string) (string, error) {
	var (
		ok  bool
		raw interface{}
		iss string
	)
	raw, ok = claims[key]
	if !ok {
		return "", nil
	}
	iss, ok = raw.(string)
	if !ok {
		err := fmt.Errorf("key %s is invalid", key)
		return "", err
	}
	return iss, nil
}
