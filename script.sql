DROP DATABASE IF EXISTS cooks_delight_db;
CREATE DATABASE cooks_delight_db;
USE cooks_delight_db;

-- 1) USERS
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user','admin') NOT NULL DEFAULT 'user',
  full_name VARCHAR(100),
  bio TEXT,
  profile_image_url VARCHAR(255),
  google_id VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2) CATEGORIES
CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
);

-- 3) RECIPES (thêm origin_* để hiển thị bản đồ vùng xuất xứ)
CREATE TABLE recipes (
  recipe_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,

  title VARCHAR(255) NOT NULL,
  slug  VARCHAR(255) NOT NULL UNIQUE,

  -- mô tả & SEO
  description TEXT,
  meta_description VARCHAR(255),
  keywords VARCHAR(255),

  -- media & thời gian
  main_image_url VARCHAR(255),
  prep_time VARCHAR(50),
  cook_time VARCHAR(50),
  total_time VARCHAR(50),

  -- analytics
  views INT NOT NULL DEFAULT 0,

  difficulty ENUM('easy','medium','hard') DEFAULT 'easy',
  is_featured BOOLEAN DEFAULT FALSE,

  -- nội dung chi tiết
  instructions_intro TEXT NULL,
  instructions TEXT NOT NULL,

  -- chỉ dẫn theo giai đoạn
  prep_instructions TEXT NULL,
  cook_instructions TEXT NULL,

  -- tips
  do_tips   TEXT NULL,
  dont_tips TEXT NULL,

  -- video
  video_url VARCHAR(255) NULL,

  -- === Location: vùng xuất xứ/khai sinh món ăn ===
  origin_place VARCHAR(150) NULL,      
  origin_zoom  TINYINT UNSIGNED NULL DEFAULT 11,  -- mức zoom 8..13
  origin_map_embed_url VARCHAR(255) NULL,  -- nếu dùng My Maps: https://www.google.com/maps/d/embed?mid=...

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 4) Nhiều-category cho 1 recipe
CREATE TABLE recipe_categories (
  recipe_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (recipe_id, category_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- 5) INGREDIENTS (1-n cho mỗi recipe)
CREATE TABLE recipe_ingredients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  quantity VARCHAR(40) NULL,
  unit VARCHAR(24) NULL,
  note VARCHAR(120) NULL,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 6) INSTRUCTION SECTIONS
CREATE TABLE recipe_instruction_sections (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  section_title VARCHAR(120) NOT NULL,
  section_body  TEXT NOT NULL,  -- dùng \n cho bullet
  sort_order INT DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 7) EQUIPMENT (tuỳ chọn)
CREATE TABLE recipe_equipment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

CREATE TABLE contact_messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(255),
  message TEXT NOT NULL,
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);