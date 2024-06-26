CREATE TABLE IF NOT EXISTS profiles (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    session_id VARCHAR NOT NULL UNIQUE,
    display_name VARCHAR(255),
    birthday DATE,
    gender VARCHAR(100),
    location TEXT,
    description TEXT,
    height INTEGER NOT NULL DEFAULT 0 CHECK(height >= 0),
    weight INTEGER NOT NULL DEFAULT 0 CHECK(weight >= 0),
    is_deleted BOOL NOT NULL DEFAULT false,
    is_blocked BOOL NOT NULL DEFAULT false,
    is_premium BOOL NOT NULL DEFAULT false,
    is_show_distance BOOL NOT NULL DEFAULT false,
    is_invisible BOOL NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
    last_online TIMESTAMP NOT NULL CHECK (last_online >= created_at)
);

CREATE TABLE IF NOT EXISTS profile_complaints (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    profile_id BIGINT NOT NULL,
    complaint_user_id BIGINT NOT NULL,
    reason TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
    CONSTRAINT fk_profile_complaints_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_telegram (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    profile_id BIGINT,
    telegram_id BIGINT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    language_code VARCHAR,
    allows_write_to_pm BOOL,
    query_id TEXT,
    chat_id BIGINT,
    CONSTRAINT fk_profile_telegram_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE IF NOT EXISTS profile_navigators (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    profile_id BIGINT NOT NULL,
    location geometry(Point,  4326),
    CONSTRAINT fk_profile_navigators_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_images (
     id BIGSERIAL NOT NULL PRIMARY KEY,
     profile_id BIGINT NOT NULL,
     name VARCHAR(255),
     url TEXT,
     size INTEGER,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
     is_deleted bool NOT NULL DEFAULT false,
     is_blocked bool NOT NULL DEFAULT false,
     is_primary bool NOT NULL DEFAULT false,
     is_private bool NOT NULL DEFAULT false,
     CONSTRAINT fk_profile_images_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_filters (
     id BIGSERIAL NOT NULL PRIMARY KEY,
     profile_id BIGINT NOT NULL,
     search_gender VARCHAR(100),
     looking_for VARCHAR(100),
     age_from INTEGER,
     age_to INTEGER,
     distance INTEGER,
     page INTEGER,
     size INTEGER,
     CONSTRAINT fk_profile_filters_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_reviews (
     id BIGSERIAL NOT NULL PRIMARY KEY,
     profile_id BIGINT NOT NULL,
     message TEXT,
     rating DECIMAL(3,  1),
     has_deleted BOOL NOT NULL DEFAULT false,
     has_edited BOOL NOT NULL DEFAULT false,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
     CONSTRAINT fk_profile_reviews_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_likes (
     id BIGSERIAL NOT NULL PRIMARY KEY,
     profile_id BIGINT NOT NULL,
     likedUser_id BIGINT NOT NULL,
     is_liked BOOL NOT NULL DEFAULT false,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
     CONSTRAINT fk_profile_likes_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);

CREATE TABLE IF NOT EXISTS profile_blocks (
     id BIGSERIAL NOT NULL PRIMARY KEY,
     profile_id BIGINT NOT NULL,
     blocked_user_id BIGINT NOT NULL,
     is_blocked BOOL NOT NULL DEFAULT false,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP NULL CHECK (updated_at >= created_at),
     CONSTRAINT fk_profile_blocks_profile_id FOREIGN KEY (profile_id) REFERENCES profiles (id)
);
