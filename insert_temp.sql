USE cooks_delight_db;

-- ===================== Ensure category variables exist =====================
SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug='breakfast' LIMIT 1);
SET @cat_lunch     = (SELECT category_id FROM categories WHERE slug='lunch' LIMIT 1);
SET @cat_dinner    = (SELECT category_id FROM categories WHERE slug='dinner' LIMIT 1);

-- ===================== Resolve recipe_id variables by slug (safe re-bind) =====================
SET @r_chicken      = (SELECT recipe_id FROM recipes WHERE slug='lemon-garlic-roasted-chicken' LIMIT 1);
SET @r_salmon       = (SELECT recipe_id FROM recipes WHERE slug='honey-soy-glazed-salmon' LIMIT 1);
SET @r_pasta        = (SELECT recipe_id FROM recipes WHERE slug='creamy-tomato-basil-pasta' LIMIT 1);

SET @r_scallion     = (SELECT recipe_id FROM recipes WHERE slug='crispy-scallion-pancakes' LIMIT 1);
SET @r_lemongrass   = (SELECT recipe_id FROM recipes WHERE slug='spicy-lemongrass-beef-rice-bowl' LIMIT 1);
SET @r_risotto      = (SELECT recipe_id FROM recipes WHERE slug='creamy-mushroom-risotto' LIMIT 1);

SET @r_shak         = (SELECT recipe_id FROM recipes WHERE slug='shakshuka-with-feta' LIMIT 1);
SET @r_bulgogi      = (SELECT recipe_id FROM recipes WHERE slug='spicy-pork-bulgogi-bowl' LIMIT 1);
SET @r_greencurry   = (SELECT recipe_id FROM recipes WHERE slug='thai-green-curry-with-chicken' LIMIT 1);

SET @r_tamago       = (SELECT recipe_id FROM recipes WHERE slug='tamagoyaki-breakfast-sando' LIMIT 1);
SET @r_chickpea     = (SELECT recipe_id FROM recipes WHERE slug='mediterranean-chickpea-and-feta-salad' LIMIT 1);
SET @r_tagine       = (SELECT recipe_id FROM recipes WHERE slug='moroccan-chicken-tagine-with-apricots' LIMIT 1);

SET @r_oats         = (SELECT recipe_id FROM recipes WHERE slug='banana-nut-overnight-oats' LIMIT 1);
SET @r_chipotle     = (SELECT recipe_id FROM recipes WHERE slug='chipotle-chicken-burrito-bowl' LIMIT 1);
SET @r_butter       = (SELECT recipe_id FROM recipes WHERE slug='butter-chicken-murgh-makhani' LIMIT 1);

-- ===========================================================================
-- 1) RECIPE ⇄ CATEGORIES (idempotent)
-- ===========================================================================
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_chicken,   @cat_dinner),
(@r_salmon,    @cat_dinner),
(@r_pasta,     @cat_lunch),

(@r_scallion,  @cat_breakfast),
(@r_lemongrass,@cat_lunch),
(@r_risotto,   @cat_dinner),

(@r_shak,      @cat_breakfast),
(@r_bulgogi,   @cat_lunch),
(@r_greencurry,@cat_dinner),

(@r_tamago,    @cat_breakfast),
(@r_chickpea,  @cat_lunch),
(@r_tagine,    @cat_dinner),

(@r_oats,      @cat_breakfast),
(@r_chipotle,  @cat_lunch),
(@r_butter,    @cat_dinner);

-- ===========================================================================
-- 2) RECIPE_EQUIPMENT (clear then insert)
--    sort_order tăng dần; đặt tên dụng cụ ngắn gọn, thực tế
-- ===========================================================================
-- Chicken roast
DELETE FROM recipe_equipment WHERE recipe_id=@r_chicken;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_chicken,'Roasting pan',1),
(@r_chicken,'Rack (optional)',2),
(@r_chicken,'Probe thermometer',3),
(@r_chicken,'Chef knife',4),
(@r_chicken,'Cutting board',5);

-- Honey soy salmon
DELETE FROM recipe_equipment WHERE recipe_id=@r_salmon;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_salmon,'Skillet (nonstick or SS)',1),
(@r_salmon,'Fish spatula',2),
(@r_salmon,'Tongs',3);

-- Creamy tomato basil pasta
DELETE FROM recipe_equipment WHERE recipe_id=@r_pasta;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_pasta,'Pasta pot',1),
(@r_pasta,'Skillet/Saucepan',2),
(@r_pasta,'Ladle',3);

-- Scallion pancakes
DELETE FROM recipe_equipment WHERE recipe_id=@r_scallion;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_scallion,'Mixing bowl',1),
(@r_scallion,'Rolling pin',2),
(@r_scallion,'Skillet',3);

-- Lemongrass beef bowl
DELETE FROM recipe_equipment WHERE recipe_id=@r_lemongrass;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_lemongrass,'Wok/Skillet',1),
(@r_lemongrass,'Knife & board',2);

-- Mushroom risotto
DELETE FROM recipe_equipment WHERE recipe_id=@r_risotto;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_risotto,'Sauté pan (wide)',1),
(@r_risotto,'Small pot (stock)',2),
(@r_risotto,'Ladle',3);

-- Shakshuka
DELETE FROM recipe_equipment WHERE recipe_id=@r_shak;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_shak,'Skillet with lid',1),
(@r_shak,'Wooden spoon',2);

-- Pork bulgogi bowl
DELETE FROM recipe_equipment WHERE recipe_id=@r_bulgogi;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_bulgogi,'Skillet (very hot)',1),
(@r_bulgogi,'Tongs',2);

-- Thai green curry
DELETE FROM recipe_equipment WHERE recipe_id=@r_greencurry;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_greencurry,'Saucepan/Wok',1),
(@r_greencurry,'Ladle',2);

-- Tamagoyaki sando
DELETE FROM recipe_equipment WHERE recipe_id=@r_tamago;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_tamago,'Tamagoyaki pan (hoặc chảo nhỏ)',1),
(@r_tamago,'Chopsticks/Spatula',2),
(@r_tamago,'Bread knife',3);

-- Chickpea & feta salad
DELETE FROM recipe_equipment WHERE recipe_id=@r_chickpea;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_chickpea,'Mixing bowl lớn',1),
(@r_chickpea,'Whisk',2);

-- Moroccan tagine
DELETE FROM recipe_equipment WHERE recipe_id=@r_tagine;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_tagine,'Dutch oven/Tagine pot',1),
(@r_tagine,'Wooden spoon',2);

-- Banana-nut overnight oats
DELETE FROM recipe_equipment WHERE recipe_id=@r_oats;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_oats,'Mixing bowl',1),
(@r_oats,'Jars with lids',2);

-- Chipotle chicken bowl
DELETE FROM recipe_equipment WHERE recipe_id=@r_chipotle;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_chipotle,'Skillet/Grill pan',1),
(@r_chipotle,'Mixing bowl (sauce)',2);

-- Butter chicken
DELETE FROM recipe_equipment WHERE recipe_id=@r_butter;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_butter,'Sauté pan',1),
(@r_butter,'Blender',2);