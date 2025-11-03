USE cooks_delight_db;

SET @pass_hash = '';
INSERT INTO users (username, email, password_hash, full_name, bio, profile_image_url)
VALUES ('isabela_russo','isabela.russo@cooksdelight.com',@pass_hash,'Isabela Russo','Bonjour and welcome to the heart of my kitchen!','/assets/images/author_isabela.jpg');
SET @author_id = LAST_INSERT_ID();

INSERT INTO categories (name, slug) VALUES
('Breakfast', 'breakfast'),
('Lunch', 'lunch'),
('Dinner', 'dinner');

INSERT INTO recipes (user_id, title, slug, meta_description, keywords, ingredients, instructions, main_image_url, prep_time, cook_time, total_time, servings, is_featured) VALUES
(@author_id,'Berry Bliss Smoothie Bowl','berry-bliss-smoothie-bowl','A vibrant and healthy berry smoothie bowl.','smoothie, berry, breakfast, healthy','1 cup mixed berries (frozen), 1 banana, 1/2 cup almond milk','1. Blend all ingredients until smooth. 2. Pour into bowl and top with granola.','images/recipe_smoothie_bowl.png','5 min','0 min','5 min','1 serving',FALSE),
(@author_id,'Avocado Toast with Chili Flakes','avocado-toast-chili-flakes','Creamy smashed avocado on toasted sourdough with chili flakes.','breakfast, avocado toast, healthy','1 slice sourdough, 1/2 avocado, chili flakes, lemon juice, salt','1. Toast bread. 2. Smash avocado. 3. Spread and top with chili flakes.','images/recipe_avocado_toast.jpg','5 min','0 min','5 min','1 serving',FALSE),
(@author_id,'Banana Oat Pancakes','banana-oat-pancakes','Fluffy flourless pancakes made with banana and oats.','breakfast, pancakes, banana, oats','1 banana, 1 egg, 1/4 cup oats, pinch cinnamon','1. Blend all. 2. Pan-fry on low heat 2-3 min/side.','images/recipe_banana_oat_pancakes.jpg','5 min','6 min','11 min','2 servings',TRUE),
(@author_id,'Vietnamese Fried Egg Baguette','vietnamese-fried-egg-baguette','Crispy baguette with egg, pickled carrots, cucumber, and chili sauce.','banh mi, vietnamese, breakfast','1 baguette, 1 fried egg, pickled carrots, cucumber, chili sauce, cilantro','1. Fry egg. 2. Cut baguette. 3. Add pickles and herbs.','images/recipe_vietnamese_baguette.jpg','5 min','5 min','10 min','1 serving',TRUE),
(@author_id,'Mediterranean Breakfast Bowl','mediterranean-breakfast-bowl','Couscous, veggies, and soft-boiled egg — energizing start.','mediterranean, breakfast bowl, healthy','1/2 cup couscous, tomatoes, cucumber, olives, 1 egg, olive oil','1. Cook couscous. 2. Arrange with veggies and egg. 3. Drizzle olive oil.','images/recipe_mediterranean_bowl.jpg','10 min','5 min','15 min','1 serving',FALSE),
(@author_id,'Decadent Chocolate Mousse','decadent-chocolate-mousse','Rich and airy decadent chocolate mousse.','chocolate, mousse, dessert, easy','200g dark chocolate, 300ml whipping cream, 50g sugar','1. Melt chocolate. 2. Whip cream. 3. Fold gently.','images/recipe_chocolate_mousse.jpg','10 min','0 min','10 min','6 servings',TRUE),
(@author_id,'Mediterranean Quinoa Salad','mediterranean-quinoa-salad','Bright quinoa salad with veggies and feta.','lunch, quinoa, salad, mediterranean','Cooked quinoa, cucumber, cherry tomato, olives, feta, lemon, olive oil','1. Chop veggies. 2. Toss with quinoa and dressing.','images/recipe_quinoa_salad.jpg','10 min','0 min','10 min','2 servings',TRUE),
(@author_id,'Grilled Chicken Caesar Wrap','grilled-chicken-caesar-wrap','Grilled chicken with Caesar dressing in a wrap.','lunch wrap, chicken caesar','Grilled chicken, romaine, parmesan, tortilla, Caesar dressing','1. Slice chicken. 2. Toss and wrap.','images/recipe_chicken_caesar_wrap.jpg','8 min','5 min','13 min','1 serving',FALSE),
(@author_id,'Creamy Tomato Basil Pasta','creamy-tomato-basil-pasta','Tomato cream sauce pasta with basil.','pasta, tomato, creamy, lunch','Pasta, tomato sauce, cream, garlic, basil, olive oil','1. Boil pasta. 2. Simmer sauce. 3. Combine.','images/recipe_tomato_basil_pasta.jpg','5 min','12 min','17 min','2 servings',TRUE),
(@author_id,'Roasted Veggie Buddha Bowl','roasted-veggie-buddha-bowl','Sweet potato, chickpeas, greens, tahini drizzle.','buddha bowl, vegetarian, lunch','Sweet potato, chickpeas, spinach, tahini, lemon, olive oil','1. Roast veggies. 2. Assemble bowl.','images/recipe_buddha_bowl.jpg','10 min','20 min','30 min','2 servings',FALSE),
(@author_id,'Lemon Garlic Roasted Chicken','lemon-garlic-roasted-chicken','Juicy roasted chicken with lemon and garlic.','chicken, lemon, garlic, roast, dinner','1 whole chicken, garlic, lemon, butter, rosemary','1. Preheat oven. 2. Season chicken. 3. Roast 75 min.','images/recipe_lemon_garlic.png','15 min','1 hr 15 min','1 hr 30 min','4 servings',TRUE),
(@author_id,'Honey Soy Glazed Salmon','honey-soy-glazed-salmon','Salmon with sticky honey-soy-garlic glaze.','dinner, salmon, honey soy glaze','Salmon, soy sauce, honey, garlic, ginger, sesame oil','1. Sear salmon. 2. Add glaze until sticky.','images/recipe_honey_soy_salmon.jpg','5 min','10 min','15 min','2 servings',TRUE),
(@author_id,'Mushroom Truffle Risotto','mushroom-truffle-risotto','Creamy Arborio rice with mushrooms and truffle oil.','dinner, risotto, mushroom','Arborio rice, mushrooms, stock, parmesan, truffle oil','1. Toast rice. 2. Add stock gradually. 3. Finish with truffle.','images/recipe_mushroom_risotto.jpg','10 min','25 min','35 min','2 servings',TRUE),
(@author_id,'Slow Cooker Beef Stew','slow-cooker-beef-stew','Beef stew with carrots and potatoes in savory broth.','dinner, beef stew, slow cooker','Beef, potatoes, carrots, onion, broth, tomato paste','1. Brown beef. 2. Add all to slow cooker ~6h.','images/recipe_beef_stew.jpg','15 min','6 hr','6 hr 15 min','4 servings',FALSE),
(@author_id,'Spicy Cajun Chicken Pasta','spicy-cajun-chicken-pasta','Creamy, spicy Cajun chicken pasta.','dinner, cajun, pasta, spicy','Chicken, Cajun seasoning, cream, garlic, bell pepper, penne','1. Sear chicken. 2. Make sauce. 3. Toss with pasta.','images/recipe_cajun_chicken_pasta.jpg','10 min','20 min','30 min','2 servings',FALSE);

SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug = 'breakfast');
SET @cat_lunch = (SELECT category_id FROM categories WHERE slug = 'lunch');
SET @cat_dinner = (SELECT category_id FROM categories WHERE slug = 'dinner');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_breakfast FROM recipes
WHERE slug IN ('berry-bliss-smoothie-bowl','avocado-toast-chili-flakes','banana-oat-pancakes','vietnamese-fried-egg-baguette','mediterranean-breakfast-bowl');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_lunch FROM recipes
WHERE slug IN ('decadent-chocolate-mousse','mediterranean-quinoa-salad','grilled-chicken-caesar-wrap','creamy-tomato-basil-pasta','roasted-veggie-buddha-bowl');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_dinner FROM recipes
WHERE slug IN ('lemon-garlic-roasted-chicken','honey-soy-glazed-salmon','mushroom-truffle-risotto','slow-cooker-beef-stew','spicy-cajun-chicken-pasta');
