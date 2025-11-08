DROP DATABASE IF EXISTS cooks_delight_db;
CREATE DATABASE cooks_delight_db;
USE cooks_delight_db;

-- 1) USERS
CREATE TABLE users (
  user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(40) NOT NULL UNIQUE,
  email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL UNIQUE,
  password_hash VARCHAR(150) NOT NULL,
  role ENUM('user','admin') NOT NULL DEFAULT 'user',
  full_name VARCHAR(40),   
  bio TEXT,
  profile_image_url VARCHAR(255),
  google_id VARCHAR(50) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2) CATEGORIES
CREATE TABLE categories (
  category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(15) NOT NULL UNIQUE,
  slug VARCHAR(15) NOT NULL UNIQUE
);

-- 3) RECIPES
CREATE TABLE recipes (
  recipe_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED,
  title VARCHAR(80) NOT NULL,
  slug  VARCHAR(60) NOT NULL UNIQUE,
  -- mô tả & SEO
  description TEXT,
  meta_description VARCHAR(150),
  keywords VARCHAR(100),
  main_image_url VARCHAR(255),
  prep_minutes  SMALLINT UNSIGNED,               -- 0..65535 phút (~45 ngày), dư dùng
  cook_minutes  SMALLINT UNSIGNED,
  total_minutes SMALLINT UNSIGNED,  
  views INT NOT NULL DEFAULT 0,
  difficulty ENUM('easy','medium','hard') DEFAULT 'easy',
  is_featured BOOLEAN DEFAULT FALSE,
  instructions_intro TEXT NULL,
  video_url VARCHAR(255) NULL,
  origin_place VARCHAR(80) NULL,      
  origin_zoom  TINYINT UNSIGNED NULL DEFAULT 11,  -- mức zoom 8..13
  origin_map_embed_url VARCHAR(255) NULL,         -- nếu dùng My Maps: https://www.google.com/maps/d/embed?mid=...

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE recipe_notes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT UNSIGNED NOT NULL,
  content_type ENUM('prep','cook','do','dont') NOT NULL,
  note_text VARCHAR(255) NOT NULL,
  sort_order SMALLINT UNSIGNED DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 4) Nhiều-category cho 1 recipe
CREATE TABLE recipe_categories (
  recipe_id INT UNSIGNED NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (recipe_id, category_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- 5) INGREDIENTS (1-n cho mỗi recipe)
CREATE TABLE recipe_ingredients (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT UNSIGNED NOT NULL,
  name VARCHAR(120) NOT NULL,
  quantity VARCHAR(20) NULL,
  unit VARCHAR(20) NULL,
  note VARCHAR(120) NULL,
  sort_order SMALLINT UNSIGNED DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 6) INSTRUCTION SECTIONS
CREATE TABLE recipe_instruction_sections (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT UNSIGNED NOT NULL,
  section_title VARCHAR(120) NOT NULL,
  sort_order SMALLINT UNSIGNED DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

CREATE TABLE recipe_instruction_steps (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  section_id INT UNSIGNED NOT NULL,
  step_text VARCHAR(255) NOT NULL,
  sort_order SMALLINT UNSIGNED DEFAULT 0,
  FOREIGN KEY (section_id) REFERENCES recipe_instruction_sections(id) ON DELETE CASCADE
);

-- 7) EQUIPMENT (tuỳ chọn)
CREATE TABLE recipe_equipment (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT UNSIGNED NOT NULL,
  name VARCHAR(40) NOT NULL,
  sort_order SMALLINT UNSIGNED DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

CREATE TABLE contact_messages (
  message_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(255),
  message TEXT NOT NULL,
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);