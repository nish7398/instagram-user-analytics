-- ============================================
-- INSTAGRAM USER ANALYTICS
-- Database Schema — MySQL
-- Author: Nishant Jaiswal
-- ============================================

CREATE DATABASE IF NOT EXISTS instagram_analytics;
USE instagram_analytics;

-- ============================================
-- TABLE 1: USERS
-- ============================================
CREATE TABLE users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(100) NOT NULL UNIQUE,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login  DATETIME,
    is_verified TINYINT(1)   NOT NULL DEFAULT 0,
    INDEX idx_created_at (created_at),
    INDEX idx_last_login (last_login)
);

-- ============================================
-- TABLE 2: PHOTOS
-- ============================================
CREATE TABLE photos (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    image_url   VARCHAR(255) NOT NULL,
    user_id     INT          NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    caption     VARCHAR(500),
    location    VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id  (user_id),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- TABLE 3: COMMENTS
-- ============================================
CREATE TABLE comments (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(500) NOT NULL,
    user_id      INT          NOT NULL,
    photo_id     INT          NOT NULL,
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (photo_id) REFERENCES photos(id) ON DELETE CASCADE,
    INDEX idx_photo_id (photo_id),
    INDEX idx_user_id  (user_id)
);

-- ============================================
-- TABLE 4: LIKES
-- ============================================
CREATE TABLE likes (
    user_id    INT      NOT NULL,
    photo_id   INT      NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, photo_id),
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (photo_id) REFERENCES photos(id) ON DELETE CASCADE,
    INDEX idx_photo_id (photo_id)
);

-- ============================================
-- TABLE 5: FOLLOWS
-- ============================================
CREATE TABLE follows (
    follower_id  INT      NOT NULL,
    followee_id  INT      NOT NULL,
    created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_followee_id (followee_id)
);

-- ============================================
-- TABLE 6: TAGS
-- ============================================
CREATE TABLE tags (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    tag_name   VARCHAR(50) NOT NULL UNIQUE,
    created_at DATE        NOT NULL DEFAULT (CURRENT_DATE)
);

-- ============================================
-- TABLE 7: PHOTO_TAGS
-- ============================================
CREATE TABLE photo_tags (
    photo_id   INT  NOT NULL,
    tag_id     INT  NOT NULL,
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (photo_id, tag_id),
    FOREIGN KEY (photo_id) REFERENCES photos(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)   REFERENCES tags(id)   ON DELETE CASCADE
);