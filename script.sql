DROP DATABASE IF EXISTS cooks_delight_db;
CREATE DATABASE cooks_delight_db;
USE cooks_delight_db;

-- 1) USERS
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  email_verified TINYINT(1) DEFAULT 0,
  verify_token VARCHAR(64) DEFAULT NULL,
  password_hash VARCHAR(255) NOT NULL,
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

-- 3) RECIPES (TỐI GIẢN: mô tả, instructions đầy đủ, và DOs/DON’Ts gộp 1 trường)
CREATE TABLE recipes (
  recipe_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,

  -- mô tả, SEO
  description TEXT,                 -- mô tả ngắn trên hero
  meta_description VARCHAR(255),
  keywords VARCHAR(255),

  -- hero & time/servings
  main_image_url VARCHAR(255),      -- chỉ 1 ảnh đại diện (gallery bỏ)
  prep_time VARCHAR(50),
  cook_time VARCHAR(50),
  total_time VARCHAR(50),
  servings VARCHAR(50),
  difficulty ENUM('easy','medium','hard') DEFAULT 'easy',
  is_featured BOOLEAN DEFAULT FALSE,

  -- nội dung chi tiết
  instructions_intro TEXT NULL,     -- đoạn mở đầu phần INSTRUCTIONS (tuỳ chọn)
  instructions TEXT NOT NULL,       -- hướng dẫn đầy đủ, định dạng bằng \n hoặc dấu đầu dòng
  dos_donts TEXT NULL,              -- DOs/DON’Ts gộp 1 trường (viết theo bullet)

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

-- 5) INGREDIENTS (giữ chuẩn hoá để render danh sách đẹp)
CREATE TABLE recipe_ingredients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,   -- "lemon", "garlic"
  quantity VARCHAR(40) NULL,    -- "2", "1 tbsp"
  unit VARCHAR(24) NULL,        -- "g", "tbsp", ...
  note VARCHAR(120) NULL,       -- "minced", "sliced"
  sort_order INT DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 6) EQUIPMENT (tuỳ chọn)
CREATE TABLE recipe_equipment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 7) NUTRITION (tuỳ chọn)
CREATE TABLE recipe_nutrition (
  recipe_id INT PRIMARY KEY,
  calories INT,
  protein_g DECIMAL(6,2),
  fat_g DECIMAL(6,2),
  carbs_g DECIMAL(6,2),
  note VARCHAR(255),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE
);

-- 8) STORES (Where to buy) + mapping
CREATE TABLE stores (
  store_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  google_maps_url VARCHAR(255),
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  phone VARCHAR(20),
  store_type ENUM('supermarket','butcher','market','online') NULL,
  price_level TINYINT NULL
);

CREATE TABLE recipe_stores (
  recipe_id INT NOT NULL,
  store_id INT NOT NULL,
  PRIMARY KEY (recipe_id, store_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
  FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE
);

-- 9) SUBSCRIBERS
CREATE TABLE subscribers (
  subscriber_id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) NOT NULL UNIQUE,
  subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10) CONTACT MESSAGES
CREATE TABLE contact_messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(255),
  message TEXT NOT NULL,
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11) COMMENTS (nếu cần)
CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  recipe_id INT NOT NULL,
  user_id INT,
  guest_name VARCHAR(100),
  comment_text TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  parent_comment_id INT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE
);

-- 12) PASSWORD RESET (tuỳ chọn)
CREATE TABLE password_resets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL 30 MINUTE),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
