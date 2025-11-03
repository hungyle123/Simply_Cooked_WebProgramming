USE cooks_delight_db;
INSERT INTO recipes (
    user_id, title, slug, meta_description, keywords,
    ingredients, instructions, main_image_url,
    prep_time, cook_time, total_time, servings, is_featured
)
VALUES
(
    @author_id,
    'Avocado Toast with Chili Flakes',
    'avocado-toast-chili-flakes',
    'Creamy smashed avocado on toasted sourdough with a kick of chili flakes and lemon.',
    'breakfast, avocado toast, healthy, quick',
    '1 slice sourdough, 1/2 ripe avocado, chili flakes, lemon juice, salt',
    '1. Toast bread. 2. Smash avocado with lemon, salt. 3. Spread and top with chili flakes.',
    'images/recipe_avocado_toast.jpg',
    '5 min', '0 min', '5 min', '1 serving',
    FALSE
),
(
    @author_id,
    'Banana Oat Pancakes',
    'banana-oat-pancakes',
    'Fluffy flourless pancakes made with banana, oats, and egg. No refined sugar.',
    'breakfast, pancakes, banana, oats',
    '1 banana, 1 egg, 1/4 cup oats, pinch cinnamon',
    '1. Blend all. 2. Pan-fry on low heat 2-3 min/side.',
    'images/recipe_banana_oat_pancakes.jpg',
    '5 min', '6 min', '11 min', '2 servings',
    TRUE
),
(
    @author_id,
    'Vietnamese Fried Egg Baguette',
    'vietnamese-fried-egg-baguette',
    'Crispy baguette filled with sunny-side-up egg, pickled carrots, cucumber, and chili sauce — a classic Saigon morning bite.',
    'banh mi, vietnamese, breakfast, sandwich, egg',
    '1 small baguette, 1 fried egg, pickled carrots, cucumber slices, cilantro, chili sauce, soy sauce',
    '1. Fry egg until crispy edges. 2. Cut baguette, add pickles and herbs. 3. Place egg inside and drizzle sauce.',
    'images/recipe_vietnamese_baguette.jpg',
    '5 min', '5 min', '10 min', '1 serving',
    TRUE
),
(
    @author_id,
    'Shrimp and Ginger Rice Porridge',
    'shrimp-ginger-rice-porridge',
    'Warm and soothing rice porridge simmered with shrimp, ginger, and scallions — comfort breakfast in a bowl.',
    'congee, porridge, shrimp, vietnamese, breakfast',
    '1/2 cup jasmine rice, 150g shrimp, 1 tsp minced ginger, salt, fish sauce, scallions',
    '1. Simmer rice until soft. 2. Add shrimp and season. 3. Garnish with scallions and serve hot.',
    'images/recipe_shrimp_porridge.jpg',
    '10 min', '25 min', '35 min', '2 servings',
    FALSE
),
(
    @author_id,
    'Vietnamese Pork Vermicelli Bowl',
    'vietnamese-pork-vermicelli-bowl',
    'Fresh rice noodles with grilled pork, herbs, and fish sauce dressing — a light yet satisfying morning meal.',
    'bun thit nuong, vermicelli, vietnamese, breakfast, noodle',
    '100g rice vermicelli, 80g grilled pork, lettuce, herbs, fish sauce dressing',
    '1. Cook vermicelli. 2. Add grilled pork and herbs. 3. Pour dressing over and toss.',
    'images/recipe_pork_vermicelli.jpg',
    '10 min', '15 min', '25 min', '1 serving',
    FALSE
),
(
    @author_id,
    'Mediterranean Breakfast Bowl',
    'mediterranean-breakfast-bowl',
    'A nourishing bowl of couscous, cherry tomatoes, cucumber, olives, and a soft-boiled egg — light and energizing start to the day.',
    'mediterranean, breakfast bowl, healthy, egg',
    '1/2 cup couscous, cherry tomatoes, cucumber, olives, 1 egg, olive oil, salt',
    '1. Cook couscous. 2. Arrange with veggies and egg. 3. Drizzle olive oil and season.',
    'images/recipe_mediterranean_bowl.jpg',
    '10 min', '5 min', '15 min', '1 serving',
    FALSE
),
(
    @author_id,
    'Smoked Salmon Bagel',
    'smoked-salmon-bagel',
    'Toasted bagel layered with cream cheese, smoked salmon, red onion, and capers — a New York classic breakfast.',
    'bagel, salmon, breakfast, sandwich',
    '1 bagel, 2 tbsp cream cheese, smoked salmon, red onion slices, capers, dill',
    '1. Toast bagel. 2. Spread cream cheese. 3. Add salmon, onion, and capers. 4. Garnish with dill.',
    'images/recipe_salmon_bagel.jpg',
    '5 min', '0 min', '5 min', '1 serving',
    TRUE
),
(
    @author_id,
    'Turkish Menemen',
    'turkish-menemen',
    'Traditional Turkish scrambled eggs cooked with tomatoes, peppers, and spices — hearty and flavorful breakfast.',
    'menemen, turkish, eggs, breakfast',
    '2 eggs, 1 tomato, 1/2 bell pepper, olive oil, paprika, salt',
    '1. Sauté tomatoes and peppers. 2. Add eggs and stir gently. 3. Serve with bread.',
    'images/recipe_turkish_menemen.jpg',
    '5 min', '10 min', '15 min', '1 serving',
    FALSE
);

####################################################################################################

INSERT INTO recipes (
    user_id, title, slug, meta_description, keywords,
    ingredients, instructions, main_image_url,
    prep_time, cook_time, total_time, servings, is_featured
)
VALUES
(
    @author_id,
    'Mediterranean Quinoa Salad',
    'mediterranean-quinoa-salad',
    'Bright quinoa salad with cucumber, tomato, olives, feta, and lemon olive oil dressing.',
    'lunch, quinoa, salad, mediterranean',
    'Cooked quinoa, cucumber, cherry tomato, olives, feta, lemon, olive oil',
    '1. Chop veggies. 2. Toss with quinoa, feta, dressing.',
    'images/recipe_quinoa_salad.jpg',
    '10 min', '0 min', '10 min', '2 servings',
    TRUE
),
(
    @author_id,
    'Grilled Chicken Caesar Wrap',
    'grilled-chicken-caesar-wrap',
    'Juicy grilled chicken tossed with light Caesar dressing and romaine in a wrap.',
    'lunch wrap, chicken caesar, meal prep',
    'Grilled chicken breast, romaine, parmesan, tortilla, Caesar dressing',
    '1. Slice chicken. 2. Toss with lettuce + dressing. 3. Wrap tight.',
    'images/recipe_chicken_caesar_wrap.jpg',
    '8 min', '5 min', '13 min', '1 serving',
    FALSE
),
(
    @author_id,
    'Spicy Tuna Rice Bowl',
    'spicy-tuna-rice-bowl',
    'Quick lunch bowl with steamed rice, spicy mayo tuna, avocado, cucumber.',
    'lunch bowl, tuna, rice, spicy mayo',
    '1 can tuna, mayo + sriracha, cooked rice, avocado, cucumber, sesame',
    '1. Mix tuna with spicy mayo. 2. Layer over rice with toppings.',
    'images/recipe_spicy_tuna_bowl.jpg',
    '5 min', '0 min', '5 min', '1 serving',
    FALSE
),
(
    @author_id,
    'Creamy Tomato Basil Pasta',
    'creamy-tomato-basil-pasta',
    'Silky tomato cream sauce with basil over al dente pasta. Comfort lunch.',
    'pasta, tomato basil, creamy, lunch',
    'Pasta, tomato sauce, cream, garlic, basil, olive oil, salt',
    '1. Boil pasta. 2. Simmer sauce w/ cream + basil. 3. Combine.',
    'images/recipe_tomato_basil_pasta.jpg',
    '5 min', '12 min', '17 min', '2 servings',
    TRUE
),
(
    @author_id,
    'Teriyaki Chicken Rice Bento',
    'teriyaki-chicken-rice-bento',
    'Sticky-sweet teriyaki chicken served with steamed rice and sautéed veggies.',
    'lunch bento, teriyaki chicken, asian style',
    'Chicken thigh, soy sauce, mirin, sugar, rice, broccoli, sesame seeds',
    '1. Pan-sear chicken. 2. Glaze with teriyaki sauce. 3. Serve with rice.',
    'images/recipe_teriyaki_chicken_bento.jpg',
    '10 min', '15 min', '25 min', '2 servings',
    FALSE
),
(
    @author_id,
    'Roasted Veggie Buddha Bowl',
    'roasted-veggie-buddha-bowl',
    'Wholesome bowl of roasted sweet potato, chickpeas, greens, tahini drizzle.',
    'buddha bowl, vegetarian lunch, high fiber',
    'Sweet potato, chickpeas, spinach, tahini, lemon, olive oil, salt, pepper',
    '1. Roast sweet potato + chickpeas. 2. Assemble bowl with greens + tahini.',
    'images/recipe_buddha_bowl.jpg',
    '10 min', '20 min', '30 min', '2 servings',
    FALSE
);


####################################################################################################

INSERT INTO recipes (
    user_id, title, slug, meta_description, keywords,
    ingredients, instructions, main_image_url,
    prep_time, cook_time, total_time, servings, is_featured
)
VALUES
(
    @author_id,
    'Honey Soy Glazed Salmon',
    'honey-soy-glazed-salmon',
    'Pan-seared salmon finished with a sticky honey-soy-garlic glaze.',
    'dinner, salmon, honey soy glaze, quick dinner',
    'Salmon fillet, soy sauce, honey, garlic, ginger, sesame oil',
    '1. Sear salmon. 2. Add glaze ingredients to pan until sticky.',
    'images/recipe_honey_soy_salmon.jpg',
    '5 min', '10 min', '15 min', '2 servings',
    TRUE
),
(
    @author_id,
    'Creamy Garlic Butter Shrimp',
    'creamy-garlic-butter-shrimp',
    'Rich shrimp in garlic butter cream sauce. Great with pasta or crusty bread.',
    'dinner, shrimp, garlic butter, creamy',
    'Shrimp, butter, garlic, cream, parsley, lemon',
    '1. Sauté shrimp in butter. 2. Add garlic + cream. 3. Simmer til thick.',
    'images/recipe_garlic_butter_shrimp.jpg',
    '8 min', '7 min', '15 min', '2 servings',
    FALSE
),
(
    @author_id,
    'Beef and Broccoli Stir-Fry',
    'beef-and-broccoli-stirfry',
    'Takeout-style beef and broccoli with soy-garlic sauce in 20 minutes.',
    'dinner, beef and broccoli, stir fry, asian',
    'Beef slices, broccoli florets, soy sauce, garlic, cornstarch, sesame oil',
    '1. Sear beef. 2. Stir-fry broccoli. 3. Toss with sauce to coat.',
    'images/recipe_beef_broccoli.jpg',
    '10 min', '10 min', '20 min', '2 servings',
    FALSE
),
(
    @author_id,
    'Mushroom Truffle Risotto',
    'mushroom-truffle-risotto',
    'Creamy Arborio rice with mushrooms and a whisper of truffle oil.',
    'dinner, risotto, mushroom, truffle',
    'Arborio rice, mushrooms, stock, parmesan, butter, truffle oil',
    '1. Toast rice. 2. Add stock gradually while stirring. 3. Finish w/ butter + truffle.',
    'images/recipe_mushroom_risotto.jpg',
    '10 min', '25 min', '35 min', '2 servings',
    TRUE
),
(
    @author_id,
    'Slow Cooker Beef Stew',
    'slow-cooker-beef-stew',
    'Fall-apart beef stew with carrots and potatoes in a rich savory broth.',
    'dinner, beef stew, slow cooker, comfort food',
    'Beef chuck, potato, carrot, onion, beef broth, tomato paste, thyme',
    '1. Brown beef. 2. Add all to slow cooker. 3. Low heat ~6h.',
    'images/recipe_beef_stew.jpg',
    '15 min', '6 hr', '6 hr 15 min', '4 servings',
    FALSE
),
(
    @author_id,
    'Spicy Cajun Chicken Pasta',
    'spicy-cajun-chicken-pasta',
    'Creamy, spicy Cajun-seasoned chicken tossed with penne.',
    'dinner, cajun chicken, pasta, creamy spicy',
    'Chicken breast, Cajun seasoning, cream, garlic, bell pepper, penne',
    '1. Sear seasoned chicken. 2. Simmer cream sauce with peppers. 3. Toss with pasta.',
    'images/recipe_cajun_chicken_pasta.jpg',
    '10 min', '20 min', '30 min', '2 servings',
    FALSE
);

####################################################################################################

-- Lấy lại id category
SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug = 'breakfast');
SET @cat_lunch     = (SELECT category_id FROM categories WHERE slug = 'lunch');
SET @cat_dinner    = (SELECT category_id FROM categories WHERE slug = 'dinner');

SET @r_smoothie    = (SELECT recipe_id FROM recipes WHERE slug = 'berry-bliss-smoothie-bowl');
SET @r_avotoast    = (SELECT recipe_id FROM recipes WHERE slug = 'avocado-toast-chili-flakes');
SET @r_pancakes    = (SELECT recipe_id FROM recipes WHERE slug = 'banana-oat-pancakes');
SET @r_baguette    = (SELECT recipe_id FROM recipes WHERE slug = 'vietnamese-fried-egg-baguette');
SET @r_porridge    = (SELECT recipe_id FROM recipes WHERE slug = 'shrimp-ginger-rice-porridge');
SET @r_vermicelli  = (SELECT recipe_id FROM recipes WHERE slug = 'vietnamese-pork-vermicelli-bowl');
SET @r_med_bowl    = (SELECT recipe_id FROM recipes WHERE slug = 'mediterranean-breakfast-bowl');
SET @r_bagel       = (SELECT recipe_id FROM recipes WHERE slug = 'smoked-salmon-bagel');
SET @r_menemen     = (SELECT recipe_id FROM recipes WHERE slug = 'turkish-menemen');


SET @r_mousse       = (SELECT recipe_id FROM recipes WHERE slug = 'decadent-chocolate-mousse');
SET @r_quinoa       = (SELECT recipe_id FROM recipes WHERE slug = 'mediterranean-quinoa-salad');
SET @r_wrap         = (SELECT recipe_id FROM recipes WHERE slug = 'grilled-chicken-caesar-wrap');
SET @r_tuna         = (SELECT recipe_id FROM recipes WHERE slug = 'spicy-tuna-rice-bowl');
SET @r_pasta_tomato = (SELECT recipe_id FROM recipes WHERE slug = 'creamy-tomato-basil-pasta');
SET @r_teriyaki     = (SELECT recipe_id FROM recipes WHERE slug = 'teriyaki-chicken-rice-bento');
SET @r_buddha       = (SELECT recipe_id FROM recipes WHERE slug = 'roasted-veggie-buddha-bowl');


SET @r_chicken      = (SELECT recipe_id FROM recipes WHERE slug = 'lemon-garlic-roasted-chicken');
SET @r_salmon       = (SELECT recipe_id FROM recipes WHERE slug = 'honey-soy-glazed-salmon');
SET @r_shrimp       = (SELECT recipe_id FROM recipes WHERE slug = 'creamy-garlic-butter-shrimp');
SET @r_beef_broc    = (SELECT recipe_id FROM recipes WHERE slug = 'beef-and-broccoli-stirfry');
SET @r_risotto      = (SELECT recipe_id FROM recipes WHERE slug = 'mushroom-truffle-risotto');
SET @r_stew         = (SELECT recipe_id FROM recipes WHERE slug = 'slow-cooker-beef-stew');
SET @r_cajun_pasta  = (SELECT recipe_id FROM recipes WHERE slug = 'spicy-cajun-chicken-pasta');


INSERT INTO recipe_categories (recipe_id, category_id) VALUES
(@r_avotoast,   @cat_breakfast),
(@r_pancakes,   @cat_breakfast),
(@r_baguette,   @cat_breakfast),
(@r_porridge,   @cat_breakfast),
(@r_vermicelli, @cat_breakfast),
(@r_med_bowl,   @cat_breakfast),
(@r_bagel,      @cat_breakfast),
(@r_menemen,    @cat_breakfast);


INSERT INTO recipe_categories (recipe_id, category_id) VALUES
(@r_mousse,        @cat_lunch),
(@r_quinoa,        @cat_lunch),
(@r_wrap,          @cat_lunch),
(@r_tuna,          @cat_lunch),
(@r_pasta_tomato,  @cat_lunch),
(@r_teriyaki,      @cat_lunch),
(@r_buddha,        @cat_lunch);


INSERT INTO recipe_categories (recipe_id, category_id) VALUES
(@r_chicken,     @cat_dinner),
(@r_salmon,      @cat_dinner),
(@r_shrimp,      @cat_dinner),
(@r_beef_broc,   @cat_dinner),
(@r_risotto,     @cat_dinner),
(@r_stew,        @cat_dinner),
(@r_cajun_pasta, @cat_dinner);
