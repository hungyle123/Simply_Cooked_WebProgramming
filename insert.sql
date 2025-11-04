USE cooks_delight_db;

-- 1) Author
INSERT INTO users (username, email, password_hash, full_name, bio, profile_image_url)
VALUES (
  'sophia_nguyen',
  'sophia.nguyen@cooksdelight.com',
  '$2y$10$W6DkpiGSMpiQmfCkKdfPTe68Pf.y3UOc8kY8W5a.7m2JQ9/r6bXYO',
  'Sophia Nguyen',
  'Welcome to my cozy kitchen — where modern recipes meet family comfort food.',
  'images/author_sophia.jpg'
);
SET @author_id = LAST_INSERT_ID();

-- 2) Categories
INSERT INTO categories (name, slug) VALUES
('Breakfast', 'breakfast'),
('Lunch', 'lunch'),
('Dinner', 'dinner');

-- 3) Recipes (15 món)
INSERT INTO recipes (
  user_id, title, slug,
  description, meta_description, keywords,
  main_image_url, prep_time, cook_time, total_time, servings,
  difficulty, is_featured,
  instructions_intro, instructions, dos_donts
) VALUES
-- BREAKFAST
(@author_id,'Berry Bliss Smoothie Bowl','berry-bliss-smoothie-bowl',
'A vibrant and healthy berry smoothie bowl.',
'A vibrant and healthy berry smoothie bowl.',
'smoothie, berry, breakfast, healthy',
'images/recipe_smoothie_bowl.png','5 min','0 min','5 min','1 serving',
'easy',FALSE,
'This smoothie bowl is quick, refreshing and packed with antioxidants.',
'- Add mixed frozen berries, banana and almond milk to a blender.\n- Blend until completely smooth and thick.\n- Pour into a bowl and add your favorite toppings (granola, coconut flakes, fresh fruit).',
'- Do: Use frozen fruit for a thicker texture.\n- Don’t: Add too much liquid or it will be drinkable, not a bowl.'
),

(@author_id,'Avocado Toast with Chili Flakes','avocado-toast-chili-flakes',
'Creamy smashed avocado on toasted sourdough with chili flakes.',
'Creamy smashed avocado on toasted sourdough with chili flakes.',
'breakfast, avocado toast, healthy',
'images/recipe_avocado_toast.jpg','5 min','0 min','5 min','1 serving',
'easy',FALSE,
'The classic avocado toast—creamy, bright and satisfying.',
'- Toast the sourdough to your liking.\n- Smash avocado with lemon juice and salt.\n- Spread on toast and sprinkle chili flakes.\n- Serve immediately.',
'- Do: Season the avocado generously with salt and lemon.\n- Don’t: Let toast sit too long; it will get soggy.'
),

(@author_id,'Banana Oat Pancakes','banana-oat-pancakes',
'Fluffy, flourless pancakes made with banana and oats.',
'Fluffy, flourless pancakes made with banana and oats.',
'breakfast, pancakes, banana, oats',
'images/recipe_banana_oat_pancakes.jpg','5 min','6 min','11 min','2 servings',
'medium',TRUE,
'A wholesome pancake that comes together in minutes.',
'- Blend banana, egg, oats and cinnamon until smooth.\n- Heat a pan on low; lightly oil.\n- Cook small pancakes 2–3 minutes per side until golden.',
'- Do: Keep heat low for tender pancakes.\n- Don’t: Flip too soon — wait for bubbles to set.'
),

(@author_id,'Vietnamese Fried Egg Baguette','vietnamese-fried-egg-baguette',
'Crispy baguette with egg, pickles and chili sauce.',
'Crispy baguette with egg, pickles and chili sauce.',
'banh mi, vietnamese, breakfast',
'images/recipe_vietnamese_baguette.jpg','5 min','5 min','10 min','1 serving',
'easy',TRUE,
'Inspired by Vietnamese bánh mì — simple but bold.',
'- Fry an egg sunny-side up.\n- Split and warm the baguette.\n- Add pickled carrots, cucumber, herbs and chili sauce.\n- Slide in the egg and serve.',
'- Do: Warm the baguette for crunch.\n- Don’t: Overload wet sauces.'
),

(@author_id,'Mediterranean Breakfast Bowl','mediterranean-breakfast-bowl',
'Couscous, veggies, and soft-boiled egg — energizing start.',
'Couscous, veggies, and soft-boiled egg — energizing start.',
'mediterranean, breakfast bowl, healthy',
'images/recipe_mediterranean_bowl.jpg','10 min','5 min','15 min','1 serving',
'medium',FALSE,
'Balanced and satisfying.',
'- Cook couscous per package.\n- Add tomatoes, cucumber, olives and a soft-boiled egg.\n- Drizzle olive oil and season.',
'- Do: Season couscous while warm.\n- Don’t: Skip acid — a squeeze of lemon brightens it up.'
),

-- LUNCH
(@author_id,'Decadent Chocolate Mousse','decadent-chocolate-mousse',
'Rich and airy decadent chocolate mousse.',
'Rich and airy decadent chocolate mousse.',
'chocolate, mousse, dessert, easy',
'images/recipe_chocolate_mousse.jpg','10 min','0 min','10 min','6 servings',
'medium',TRUE,
'Creamy, chocolatey and light.',
'- Melt dark chocolate over a double boiler; let cool slightly.\n- Whip cold cream with sugar to soft peaks.\n- Fold chocolate into whipped cream until no streaks.\n- Chill 1 hour before serving.',
'- Do: Cool chocolate before folding.\n- Don’t: Overwhip the cream; it will turn grainy.'
),

(@author_id,'Mediterranean Quinoa Salad','mediterranean-quinoa-salad',
'Bright quinoa salad with veggies and feta.',
'Bright quinoa salad with veggies and feta.',
'lunch, quinoa, salad, mediterranean',
'images/recipe_quinoa_salad.jpg','10 min','0 min','10 min','2 servings',
'easy',TRUE,
'Crunchy, lemony and protein-rich.',
'- Fluff cooked quinoa.\n- Add cucumber, tomatoes, olives and feta.\n- Toss with olive oil and lemon; season to taste.',
'- Do: Rinse quinoa before cooking.\n- Don’t: Overdress — it will get soggy.'
),

(@author_id,'Grilled Chicken Caesar Wrap','grilled-chicken-caesar-wrap',
'Grilled chicken with Caesar dressing in a wrap.',
'Grilled chicken with Caesar dressing in a wrap.',
'lunch wrap, chicken caesar',
'images/recipe_chicken_caesar_wrap.jpg','8 min','5 min','13 min','1 serving',
'easy',FALSE,
'All the Caesar goodness in a portable wrap.',
'- Slice grilled chicken.\n- Toss romaine with Caesar dressing and parmesan.\n- Wrap in warm tortilla with the chicken.',
'- Do: Warm tortilla for easier rolling.\n- Don’t: Overload filling.'
),

(@author_id,'Creamy Tomato Basil Pasta','creamy-tomato-basil-pasta',
'Tomato cream sauce pasta with basil.',
'Tomato cream sauce pasta with basil.',
'pasta, tomato, creamy, lunch',
'images/recipe_tomato_basil_pasta.jpg','5 min','12 min','17 min','2 servings',
'easy',TRUE,
'Comforting and quick.',
'- Boil pasta until al dente.\n- Simmer tomato sauce with garlic and a splash of cream.\n- Toss pasta; add basil and serve.',
'- Do: Salt pasta water well.\n- Don’t: Overreduce sauce.'
),

(@author_id,'Roasted Veggie Buddha Bowl','roasted-veggie-buddha-bowl',
'Sweet potato, chickpeas, greens, tahini drizzle.',
'Sweet potato, chickpeas, greens, tahini drizzle.',
'buddha bowl, vegetarian, lunch',
'images/recipe_buddha_bowl.jpg','10 min','20 min','30 min','2 servings',
'medium',FALSE,
'Colorful and nourishing.',
'- Roast sweet potato and chickpeas until crisp.\n- Assemble with greens; drizzle tahini lemon sauce.',
'- Do: Roast until edges are caramelized.\n- Don’t: Skip seasoning the chickpeas.'
),

-- DINNER
(@author_id,'Lemon Garlic Roasted Chicken','lemon-garlic-roasted-chicken',
'Juicy roasted chicken with lemon and garlic.',
'Juicy roasted chicken with lemon and garlic.',
'chicken, lemon, garlic, roast, dinner',
'images/recipe_lemon_garlic.png','15 min','1 hr 15 min','1 hr 30 min','4 servings',
'hard',TRUE,
'This recipe invites you to savor the richness of a simple roast — bright citrus, aromatic garlic and golden skin.',
'PREHEAT AND PREPARE\n- Preheat oven to 375°F (190°C).\n- Rinse the chicken and pat completely dry.\n\nCITRUS INFUSION\n- Gently loosen the skin; rub minced garlic directly on the meat.\n- Slide lemon slices under the skin, covering as much area as possible.\n\nHERB BLEND\n- Mix olive oil, dried thyme, dried rosemary, salt and pepper.\n- Brush the entire chicken evenly; season cavity lightly.\n\nROAST TO PERFECTION\n- Place chicken on a roasting pan, breast side up.\n- Roast about 1 hour (or until thickest part reaches 165°F/74°C).\n- Rest 10 minutes before carving. Baste halfway for extra juiciness.',
'DO’S:\n- Thoroughly clean hands and surfaces before/after handling raw chicken.\n- Use separate cutting boards for raw meat and produce.\n- Check internal temperature reaches 165°F (74°C).\n\nDON’Ts:\n- Don’t thaw chicken at room temperature; thaw in the refrigerator.\n- Don’t overcrowd the pan — allow hot air to circulate.'
),

(@author_id,'Honey Soy Glazed Salmon','honey-soy-glazed-salmon',
'Salmon with sticky honey–soy–garlic glaze.',
'Salmon with sticky honey–soy–garlic glaze.',
'dinner, salmon, honey soy glaze',
'images/recipe_honey_soy_salmon.jpg','5 min','10 min','15 min','2 servings',
'easy',TRUE,
'Savory–sweet glaze that clings to the salmon.',
'- Pat salmon dry; season lightly.\n- Sear 2–3 minutes per side.\n- Add soy sauce, honey, garlic and ginger; reduce to a sticky glaze.\n- Spoon over salmon and serve.',
'- Do: Dry salmon for better browning.\n- Don’t: Overcook — remove when just opaque.'
),

(@author_id,'Mushroom Truffle Risotto','mushroom-truffle-risotto',
'Creamy Arborio rice with mushrooms and truffle oil.',
'Creamy Arborio rice with mushrooms and truffle oil.',
'dinner, risotto, mushroom',
'images/recipe_mushroom_risotto.jpg','10 min','25 min','35 min','2 servings',
'medium',TRUE,
'Luxurious and silky.',
'- Toast Arborio with butter until edges translucent.\n- Add hot stock gradually, stirring, until creamy.\n- Fold in sautéed mushrooms, parmesan and truffle oil.',
'- Do: Keep stock hot.\n- Don’t: Rinse the rice; starch is needed.'
),

(@author_id,'Slow Cooker Beef Stew','slow-cooker-beef-stew',
'Beef stew with carrots and potatoes in savory broth.',
'Beef stew with carrots and potatoes in savory broth.',
'dinner, beef stew, slow cooker',
'images/recipe_beef_stew.jpg','15 min','6 hr','6 hr 15 min','4 servings',
'hard',FALSE,
'Classic comfort done hands-off.',
'- Brown beef cubes.\n- Add to slow cooker with potatoes, carrots, onion, broth and tomato paste.\n- Cook on LOW ~6 hours until tender.',
'- Do: Brown meat for deeper flavor.\n- Don’t: Skimp on salt in a large stew.'
),

(@author_id,'Spicy Cajun Chicken Pasta','spicy-cajun-chicken-pasta',
'Creamy, spicy Cajun chicken pasta.',
'Creamy, spicy Cajun chicken pasta.',
'dinner, cajun, pasta, spicy',
'images/recipe_cajun_chicken_pasta.jpg','10 min','20 min','30 min','2 servings',
'medium',FALSE,
'Spicy, creamy and weeknight-fast.',
'- Sear Cajun-seasoned chicken.\n- Make a quick cream sauce with garlic and bell pepper.\n- Toss with al dente penne.',
'- Do: Reserve pasta water for the sauce.\n- Don’t: Overcook chicken.'
);

-- 4) Category mapping
SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug='breakfast');
SET @cat_lunch     = (SELECT category_id FROM categories WHERE slug='lunch');
SET @cat_dinner    = (SELECT category_id FROM categories WHERE slug='dinner');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_breakfast FROM recipes
WHERE slug IN ('berry-bliss-smoothie-bowl','avocado-toast-chili-flakes','banana-oat-pancakes','vietnamese-fried-egg-baguette','mediterranean-breakfast-bowl');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_lunch FROM recipes
WHERE slug IN ('decadent-chocolate-mousse','mediterranean-quinoa-salad','grilled-chicken-caesar-wrap','creamy-tomato-basil-pasta','roasted-veggie-buddha-bowl');

INSERT INTO recipe_categories (recipe_id, category_id)
SELECT recipe_id, @cat_dinner FROM recipes
WHERE slug IN ('lemon-garlic-roasted-chicken','honey-soy-glazed-salmon','mushroom-truffle-risotto','slow-cooker-beef-stew','spicy-cajun-chicken-pasta');

-- 5) Ingredients / Equipment / Nutrition cho 3 món tiêu biểu
-- Chicken
SET @r_chicken = (SELECT recipe_id FROM recipes WHERE slug='lemon-garlic-roasted-chicken');
DELETE FROM recipe_ingredients WHERE recipe_id=@r_chicken;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_chicken,'Whole chicken','1',NULL,'3–4 pounds',1),
(@r_chicken,'Lemon','2',NULL,'sliced',2),
(@r_chicken,'Garlic','6','cloves','minced',3),
(@r_chicken,'Olive oil','2','tbsp',NULL,4),
(@r_chicken,'Dried thyme','1','tsp',NULL,5),
(@r_chicken,'Dried rosemary','1','tsp',NULL,6),
(@r_chicken,'Salt',NULL,NULL,'to taste',7),
(@r_chicken,'Black pepper',NULL,NULL,'to taste',8);

DELETE FROM recipe_equipment WHERE recipe_id=@r_chicken;
INSERT INTO recipe_equipment (recipe_id, name, sort_order) VALUES
(@r_chicken,'Roasting pan',1),
(@r_chicken,'Meat thermometer',2),
(@r_chicken,'Kitchen twine',3);

INSERT INTO recipe_nutrition (recipe_id, calories, protein_g, fat_g, carbs_g, note)
VALUES (@r_chicken, 250, 30.0, 13.0, 5.0, 'Approximate per serving')
ON DUPLICATE KEY UPDATE calories=VALUES(calories);

-- Salmon
SET @r_salmon = (SELECT recipe_id FROM recipes WHERE slug='honey-soy-glazed-salmon');
DELETE FROM recipe_ingredients WHERE recipe_id=@r_salmon;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_salmon,'Salmon fillet','2',NULL,'portions',1),
(@r_salmon,'Soy sauce','2','tbsp',NULL,2),
(@r_salmon,'Honey','1','tbsp',NULL,3),
(@r_salmon,'Garlic','2','cloves','minced',4),
(@r_salmon,'Ginger','1','tsp','grated',5),
(@r_salmon,'Sesame oil','1','tsp',NULL,6);

INSERT INTO recipe_nutrition (recipe_id, calories, protein_g, fat_g, carbs_g, note)
VALUES (@r_salmon, 320, 28.0, 18.0, 12.0, 'Approximate per serving')
ON DUPLICATE KEY UPDATE calories=VALUES(calories);

-- Mousse
SET @r_mousse = (SELECT recipe_id FROM recipes WHERE slug='decadent-chocolate-mousse');
DELETE FROM recipe_ingredients WHERE recipe_id=@r_mousse;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_mousse,'Dark chocolate','200','g',NULL,1),
(@r_mousse,'Whipping cream','300','ml',NULL,2),
(@r_mousse,'Sugar','50','g',NULL,3);
