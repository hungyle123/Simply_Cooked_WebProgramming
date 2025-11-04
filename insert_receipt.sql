USE cooks_delight_db;

-- ===================== USERS =====================
INSERT INTO users
(username, email, password_hash, full_name, bio, profile_image_url)
VALUES
(
  'isabela_russo',
  'isabela.russo@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Isabela Russo',
  'In the world of pots and pans, I am on a mission to turn everyday meals into memorable moments. I believe cooking is equal parts craft and storytelling, where ingredients become characters and technique creates the plot. At Cooks Delight, I focus on approachable recipes with chef-level results, from quick weeknights to slow-weekend roasts. When I am not testing sauces, I am writing guides that demystify kitchen science so home cooks can shine.',
  '/images/isabela.jpg'
),
(
  'marco_lee',
  'marco.lee@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Marco Lee',
  'I am the team’s food stylist and photo wrangler, obsessed with natural light and honest textures. My philosophy is that a good picture should teach you how the food ought to look at every step, not just at the end. I document tests, tiny tweaks, and plating choices so readers can replicate the same finish at home. When the oven is on, my camera is too—capturing the sizzle, the steam, and the story.',
  '/images/marco.jpg'
),
(
  'sophia_kim',
  'sophia.kim@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Sophia Kim',
  'I edit our recipes for clarity and reliability, turning messy notes into step-by-step roadmaps. My background in technical writing meets a lifelong love for baking, so I sweat the details: gram weights, oven behavior, and substitution logic. I maintain our testing logs and quality checks to keep instructions consistent across the site. If a direction feels effortless to follow, that means my job worked.',
  '/images/sophia.jpg'
);

-- ===================== CATEGORIES =====================
INSERT INTO categories (name, slug) VALUES
('Breakfast','breakfast'),('Lunch','lunch'),('Dinner','dinner')
ON DUPLICATE KEY UPDATE name=VALUES(name);

SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug='breakfast' LIMIT 1);
SET @cat_lunch     = (SELECT category_id FROM categories WHERE slug='lunch' LIMIT 1);
SET @cat_dinner    = (SELECT category_id FROM categories WHERE slug='dinner' LIMIT 1);

-- Tác giả mặc định
SET @author_id =
  (SELECT user_id FROM users WHERE username='isabela_russo' LIMIT 1);




/* ===========================================================
   RECIPE 1: Lemon Garlic Roasted Chicken (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Lemon Garlic Roasted Chicken',
 'lemon-garlic-roasted-chicken',
 'Picture succulent chicken infused with bright lemon and aromatic garlic. The kitchen warms with citrusy, herbaceous notes as the oven preheats, promising crisp skin and juicy meat. This method focuses on repeatable results for gatherings or relaxed weekends. Steps are broken into clear stages so beginners follow with confidence. Serve with pan juices and roasted lemon for a lively, memorable finish.',
 'Juicy roasted chicken with lemon, garlic and herbs.',
 'chicken, lemon, garlic, roast, dinner',
 'images/recipe_lemon_garlic.png',
 '15 min','1 hr 15 min','1 hr 30 min',
 0,'hard',TRUE,
 'This guide goes beyond basics to help you achieve golden skin and tender meat—every time.',
 'Preheat to 375°F (190°C). Pat chicken dry. Rub minced garlic under the skin; slide lemon slices beneath the skin and into the cavity. Brush with olive oil mixed with thyme, rosemary, salt and pepper. Roast breast-side up until the thickest part reaches 165°F (74°C). Rest 10 minutes before carving; spoon over pan juices.',
 '• Preheat oven to 375°F (190°C).\n• Remove giblets; pat the chicken completely dry.\n• Gently lift the skin and rub minced garlic directly onto the meat.',
 '• Slide lemon slices under the skin and into the cavity.\n• Whisk olive oil with thyme, rosemary, salt, pepper; brush all over.\n• Roast breast-side up until internal temperature reaches 165°F (74°C); rest 10 minutes.',
 '• Wash hands and sanitize surfaces when handling raw poultry.\n• Use separate cutting boards for raw meat and produce.\n• Verify 165°F (74°C) with a probe thermometer.\n• Allow resting time for juicier slices.',
 '• Do not thaw chicken at room temperature.\n• Do not overcrowd the pan—air needs to circulate.\n• Do not carve immediately after roasting.',
 'https://www.youtube.com/watch?v=hVf9izhRThY',
 'Tuscany, Italy', 10, NULL
);

SET @r_chicken = (SELECT recipe_id FROM recipes WHERE slug='lemon-garlic-roasted-chicken' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_chicken, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_chicken;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_chicken, 'whole chicken', '1', NULL, '3-4 lb', 1),
(@r_chicken, 'lemon', '2', NULL, 'thinly sliced', 2),
(@r_chicken, 'garlic', '6', 'clove', 'minced', 3),
(@r_chicken, 'olive oil', '2', 'tbsp', NULL, 4),
(@r_chicken, 'kosher salt', '1', 'tsp', NULL, 5),
(@r_chicken, 'black pepper', '1/2', 'tsp', NULL, 6),
(@r_chicken, 'dried thyme', '1', 'tsp', NULL, 7),
(@r_chicken, 'dried rosemary', '1/2', 'tsp', NULL, 8);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_chicken;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_chicken,'PREHEAT AND PREPARE','• Preheat oven to 375°F (190°C).\n• Pat the chicken completely dry.',1),
(@r_chicken,'CITRUS INFUSION','• Rub minced garlic under the skin.\n• Slide lemon slices evenly under the skin and into the cavity.',2),
(@r_chicken,'ROAST TO PERFECTION','• Roast breast-side up until 165°F (74°C).\n• Rest 10 minutes; carve and spoon over pan juices.',3);




/* ===========================================================
   RECIPE 2: Honey Soy Glazed Salmon (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Honey Soy Glazed Salmon',
 'honey-soy-glazed-salmon',
 'A quick skillet method that turns pantry staples into a glossy, savory-sweet glaze. As the sauce reduces, it clings to the salmon and caramelizes at the edges. The result is tender fish with balanced sweetness, salt and garlic warmth. Serve with rice and steamed greens for an effortless weeknight dinner that still feels special.',
 'Salmon fillets with a sticky honey–soy–garlic glaze.',
 'salmon, honey, soy, dinner, quick',
 'images/recipe_honey_soy_salmon.jpg',
 '5 min','10 min','15 min',
 0,'easy',TRUE,
 'Fast, high-impact flavor with minimal prep.',
 'Pat salmon dry and season lightly. Sear 2–3 minutes per side. Add soy sauce, honey, minced garlic and grated ginger; simmer until thick and glossy. Spoon the glaze over the fish and serve immediately.',
 '• Pat fillets dry; season with a pinch of salt.\n• Mince garlic; grate fresh ginger.',
 '• Sear salmon 2–3 min/side.\n• Add soy + honey + garlic + ginger; reduce to a sticky glaze.\n• Remove when the center is just opaque.',
 '• Dry fish for better browning.\n• Tilt the pan and baste to coat evenly.\n• Rest 1–2 minutes before serving.',
 '• Do not overcook—remove when just opaque.\n• Do not crowd the pan; sear in batches if needed.',
 'https://www.youtube.com/watch?v=immZV3_4bmQ',
 'Hokkaido, Japan', 7, NULL
);

SET @r_salmon = (SELECT recipe_id FROM recipes WHERE slug='honey-soy-glazed-salmon' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_salmon, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_salmon;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_salmon, 'salmon fillet', '2', NULL, 'portions', 1),
(@r_salmon, 'soy sauce', '2', 'tbsp', NULL, 2),
(@r_salmon, 'honey', '1', 'tbsp', NULL, 3),
(@r_salmon, 'garlic', '2', 'clove', 'minced', 4),
(@r_salmon, 'ginger', '1', 'tsp', 'grated', 5),
(@r_salmon, 'sesame oil', '1', 'tsp', NULL, 6);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_salmon;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_salmon,'SEAR THE FISH','• Heat skillet over medium-high.\n• Sear salmon 2–3 minutes per side.',1),
(@r_salmon,'MAKE THE GLAZE','• Add soy, honey, garlic, ginger.\n• Simmer until syrupy and thick.',2),
(@r_salmon,'FINISH & SERVE','• Spoon glaze over salmon.\n• Rest briefly; serve with rice and greens.',3);




/* ===========================================================
   RECIPE 3: Creamy Tomato Basil Pasta (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Tomato Basil Pasta',
 'creamy-tomato-basil-pasta',
 'Silky tomato cream sauce that clings to every strand of pasta. Gentle garlic aromatics, a splash of cream and fresh basil create a comforting bowl in under 20 minutes. The method is simple but reliable, perfect for busy lunches or relaxed evenings. Finish with grated parmesan and a little pasta water for a glossy, restaurant-style texture.',
 'Tomato cream pasta with fresh basil.',
 'pasta, tomato, basil, lunch, quick',
 'images/recipe_tomato_basil_pasta.jpg',
 '5 min','12 min','17 min',
 0,'easy',TRUE,
 'Quick comfort: bright tomato, gentle cream, lots of basil.',
 'Boil pasta in salted water. Meanwhile, sauté garlic briefly, add tomato sauce and simmer. Stir in a splash of cream; season. Toss pasta with sauce, loosening with reserved pasta water as needed. Finish with basil and parmesan.',
 '• Salt pasta water generously.\n• Mince garlic; chop basil.',
 '• Simmer tomato sauce 5–7 minutes.\n• Add cream; adjust seasoning.\n• Toss pasta with sauce; use pasta water for gloss.',
 '• Reserve 1/2 cup pasta water for emulsifying.\n• Warm bowls before serving to keep pasta hot.',
 '• Do not overcook pasta—aim for al dente.\n• Do not brown garlic; keep it fragrant, not bitter.',
 'https://www.youtube.com/watch?v=k0QfHojj8QM',
 'Campania, Italy', 8, NULL
);

SET @r_pasta = (SELECT recipe_id FROM recipes WHERE slug='creamy-tomato-basil-pasta' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_pasta, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_pasta;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_pasta, 'pasta', '200', 'g', 'spaghetti or penne', 1),
(@r_pasta, 'garlic', '2', 'clove', 'minced', 2),
(@r_pasta, 'tomato sauce', '1', 'cup', NULL, 3),
(@r_pasta, 'heavy cream', '1/3', 'cup', NULL, 4),
(@r_pasta, 'parmesan', NULL, NULL, 'grated, to taste', 5),
(@r_pasta, 'fresh basil', NULL, NULL, 'torn', 6);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_pasta;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_pasta,'COOK THE PASTA','• Boil in well-salted water until al dente.\n• Reserve some pasta water.',1),
(@r_pasta,'SIMMER THE SAUCE','• Sauté garlic 30–45 sec.\n• Add tomato sauce; simmer gently.',2),
(@r_pasta,'TOSS & FINISH','• Add cream; season.\n• Toss pasta; use pasta water for sheen.\n• Finish with basil and parmesan.',3);

/* ===========================================================
   RECIPE A: Crispy Scallion Pancakes (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Crispy Scallion Pancakes',
 'crispy-scallion-pancakes',
 'Flaky, layered pancakes studded with heaps of scallions. A simple hot-water dough is folded and rolled to create shattering layers that fry up golden and crisp while staying chewy inside. Dip in soy–vinegar with a touch of chili for a breakfast or snack that disappears fast.',
 'Layered scallion pancakes: flaky, crisp, deeply savory.',
 'breakfast, scallion, pancake, flaky, chinese',
 'images/scallion_pancakes.jpg',
 '15 min','15 min','30 min',
 0,'medium',TRUE,
 'Hot-water dough + gentle layering = ultra-crisp edges and chewy centers.',
 'Make a hot-water dough, rest, then roll out with oil and scallions. Coil, rest again, and roll flat. Pan-fry in a thin sheen of oil until blistered and deeply golden on both sides. Slice and serve with a soy–vinegar dip.',
 '• Whisk flour and salt.\n• Stream in hot water (not boiling) while stirring with chopsticks.\n• Knead 2–3 minutes until smooth; rest 20 minutes under cover.',
 '• Roll dough thin; brush with oil; scatter scallions and a pinch of salt.\n• Roll up into a log; coil into a snail; rest 5–10 minutes; roll flat (≈18–20 cm).\n• Pan-fry 2–3 minutes/side over medium until golden and crisp; drain briefly.',
 '• Use just enough oil to coat the pan—too much makes it greasy.\n• Press gently with a spatula to encourage even browning.\n• Slice like a pizza for easy dipping.',
 '• Do not skip the resting—layers will tear and won’t puff.\n• Do not fry on high heat—outside burns before layers cook.',
 'https://www.youtube.com/watch?v=JwExHAJQ-II',
 'Shenzhen, China', 10, NULL
);

SET @r_scallion = (SELECT recipe_id FROM recipes WHERE slug='crispy-scallion-pancakes' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_scallion, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_scallion;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_scallion, 'all-purpose flour', '2', 'cup', NULL, 1),
(@r_scallion, 'hot water', '3/4', 'cup', '≈80–90°C', 2),
(@r_scallion, 'kosher salt', '1', 'tsp', NULL, 3),
(@r_scallion, 'neutral oil', '3', 'tbsp', 'plus more for frying', 4),
(@r_scallion, 'scallions', '6', 'stalk', 'thinly sliced', 5),
(@r_scallion, 'rice vinegar', '1', 'tbsp', 'for dipping sauce', 6),
(@r_scallion, 'soy sauce', '2', 'tbsp', 'for dipping sauce', 7),
(@r_scallion, 'chili flakes', '1/2', 'tsp', 'optional', 8);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_scallion;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_scallion,'MAKE THE DOUGH','• Combine flour + salt.\n• Stream in hot water while stirring.\n• Knead 2–3 min; cover and rest 20 min.',1),
(@r_scallion,'LAYER & SHAPE','• Roll thin; brush with oil.\n• Scatter scallions + pinch of salt.\n• Roll into a log; coil; rest 5–10 min.',2),
(@r_scallion,'ROLL & FRY','• Roll to 18–20 cm.\n• Pan-fry in a thin sheen of oil 2–3 min/side until deep golden.\n• Slice and serve with soy–vinegar dip.',3);



/* ===========================================================
   RECIPE B: Spicy Lemongrass Beef Rice Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Spicy Lemongrass Beef Rice Bowl',
 'spicy-lemongrass-beef-rice-bowl',
 'Fragrant lemongrass and garlic sear into thin-sliced beef for a fast, high-heat lunch. A quick nuoc cham–style dressing ties everything together over warm rice with crisp veggies and herbs. Spicy, salty, tangy—balanced in every bite.',
 'Vietnamese-style lemongrass beef over rice with nuoc cham.',
 'lunch, beef, lemongrass, vietnamese, rice bowl',
 'images/lemongrass_beef.jpg',
 '10 min','8 min','18 min',
 0,'easy',TRUE,
 'Prep sauce first; high heat, quick sear.',
 'Marinate beef briefly with lemongrass, garlic, fish sauce, sugar and chili. Sear hard and fast; toss with a splash of dressing. Serve over rice with cucumbers, pickled carrots and herbs.',
 '• Slice beef thinly across the grain.\n• Mince lemongrass (white parts), garlic and chili.\n• Whisk fish sauce, sugar, lime juice, water for dressing.',
 '• Sear beef in batches over high heat 60–90 sec.\n• Deglaze with a spoon of dressing; toss to coat.\n• Assemble bowls: rice, beef, veggies, herbs; drizzle more dressing.',
 '• Freeze beef 15 min for easier slicing.\n• Use a very hot pan to avoid steaming.\n• Add a knob of butter at the end for gloss (optional).',
 '• Do not crowd the pan—sear in batches.\n• Do not over-marinate; flavors can turn harsh.',
 'https://www.youtube.com/watch?v=sjM3QcnqjH4',
 'Ho Chi Minh City, Vietnam', 11, NULL
);

SET @r_lemongrass = (SELECT recipe_id FROM recipes WHERE slug='spicy-lemongrass-beef-rice-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_lemongrass, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_lemongrass;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_lemongrass, 'beef sirloin (thin-sliced)', '400', 'g', NULL, 1),
(@r_lemongrass, 'lemongrass (white part)', '2', 'stalk', 'finely minced', 2),
(@r_lemongrass, 'garlic', '3', 'clove', 'minced', 3),
(@r_lemongrass, 'red chili', '1', 'pc', 'sliced', 4),
(@r_lemongrass, 'fish sauce', '2', 'tbsp', NULL, 5),
(@r_lemongrass, 'sugar', '2', 'tsp', NULL, 6),
(@r_lemongrass, 'lime juice', '1', 'tbsp', NULL, 7),
(@r_lemongrass, 'water', '2', 'tbsp', 'for dressing', 8),
(@r_lemongrass, 'steamed rice', '2', 'cup', 'for serving', 9),
(@r_lemongrass, 'cucumber', '1', 'pc', 'sliced', 10),
(@r_lemongrass, 'pickled carrot', '1/2', 'cup', NULL, 11),
(@r_lemongrass, 'fresh herbs (mint/cilantro)', NULL, NULL, 'to taste', 12);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_lemongrass,'MIX THE DRESSING','• Whisk fish sauce + sugar + lime + water.\n• Adjust sweet/sour/salty to taste.',1),
(@r_lemongrass,'MARINATE & PREP','• Toss beef with lemongrass, garlic, chili + 1 tbsp dressing.\n• Rest 5–10 min while you slice veggies.',2),
(@r_lemongrass,'SEAR & ASSEMBLE','• Sear beef in batches 60–90 sec.\n• Deglaze with 1–2 tbsp dressing; toss.\n• Serve over rice with veggies + herbs; drizzle more dressing.',3);



/* ===========================================================
   RECIPE C: Creamy Mushroom Risotto (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Mushroom Risotto',
 'creamy-mushroom-risotto',
 'Classic Northern-Italian risotto, gently stirred to release starches for a luxurious, spoon-coating sauce. Mixed mushrooms bring depth while butter and parmesan finish it glossy and rich. The technique is patient but simple—and the payoff is pure comfort.',
 'Silky arborio rice with mixed mushrooms and parmesan.',
 'dinner, risotto, mushroom, italian, creamy',
 'images/mushroom_risotto.jpg',
 '10 min','25 min','35 min',
 0,'medium',TRUE,
 'Warm stock, patient stirring, and small additions of liquid are the keys.',
 'Sweat onions and mushrooms in butter and oil. Toast rice until pearly. Add wine, then stock a ladle at a time, stirring frequently until creamy and al dente. Finish with butter and parmesan; loosen with a splash of hot stock if needed.',
 '• Warm stock in a separate pot.\n• Dice onion; slice mushrooms; grate parmesan.',
 '• Sauté onion in butter + oil; add mushrooms; season.\n• Stir in rice; toast 1–2 min; add wine; reduce.\n• Add hot stock gradually, stirring until creamy and al dente.',
 '• Keep stock hot for even absorption.\n• Finish with a cold knob of butter for sheen.\n• Adjust with stock to achieve flowing, creamy texture.',
 '• Do not rinse the rice—starch is needed.\n• Do not dump in too much stock at once.',
 'https://www.youtube.com/watch?v=8ak3lUxy_yU',
 'Milan, Italy', 9, NULL
);

SET @r_risotto = (SELECT recipe_id FROM recipes WHERE slug='creamy-mushroom-risotto' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_risotto, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_risotto;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_risotto, 'arborio rice', '1 1/2', 'cup', NULL, 1),
(@r_risotto, 'mixed mushrooms', '300', 'g', 'sliced', 2),
(@r_risotto, 'yellow onion', '1/2', 'pc', 'finely diced', 3),
(@r_risotto, 'garlic', '2', 'clove', 'minced', 4),
(@r_risotto, 'dry white wine', '1/2', 'cup', NULL, 5),
(@r_risotto, 'hot chicken/veg stock', '4', 'cup', 'kept warm', 6),
(@r_risotto, 'unsalted butter', '3', 'tbsp', 'divided', 7),
(@r_risotto, 'olive oil', '1', 'tbsp', NULL, 8),
(@r_risotto, 'parmesan', '3/4', 'cup', 'finely grated', 9),
(@r_risotto, 'salt & black pepper', NULL, NULL, 'to taste', 10),
(@r_risotto, 'parsley', NULL, NULL, 'for garnish', 11);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_risotto;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_risotto,'PREP & WARM','• Heat stock in a small pot.\n• Dice onion; slice mushrooms; grate cheese.',1),
(@r_risotto,'TOAST & BUILD','• Sweat onion in butter + oil; add mushrooms; season.\n• Stir in rice; toast until edges look translucent.\n• Add wine; reduce to nearly dry.',2),
(@r_risotto,'STIR TO CREAMINESS','• Add hot stock a ladle at a time, stirring often.\n• Cook until rice is al dente and mixture creamy.\n• Finish with butter + parmesan; season to taste.',3);

/* ===========================================================
   RECIPE 4: Shakshuka with Feta (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Shakshuka with Feta',
 'shakshuka-with-feta',
 'Eggs gently poached in a bright, gently spicy tomato–pepper sauce. Crumbles of feta melt into pockets of creaminess while herbs keep it fresh. Scoop with warm bread for a breakfast that feels cozy yet vibrant.',
 'North African tomato–pepper eggs with feta and herbs.',
 'breakfast, shakshuka, eggs, tomato, feta',
 'images/placeholder_shakshuka.jpg',
 '10 min','18 min','28 min',
 0,'easy',TRUE,
 'Build a flavorful base, then crack in eggs and let them set to your preferred doneness.',
 'Sweat onions and peppers, bloom spices in olive oil, then add tomatoes to simmer into a saucy base. Nestle eggs, cover and cook just until the whites set and yolks are still jammy. Finish with feta and herbs.',
 '• Dice onion + bell pepper; mince garlic.\n• Measure spices: cumin, paprika, chili flakes.\n• Open tomatoes; ready feta + herbs.',
 '• Sauté onion + pepper in olive oil; season with salt.\n• Add garlic; bloom cumin, paprika, chili.\n• Add tomatoes; simmer 8–10 min until saucy.\n• Make wells; crack eggs; cover 5–7 min to jammy.\n• Crumble feta; scatter parsley/cilantro.',
 '• Warm your bread while the eggs set.\n• Tilt the pan and spoon sauce over whites for even cooking.',
 '• Do not overcook the yolks unless you prefer firm.\n• Do not skip blooming spices—the flavor won’t open.',
 'https://www.youtube.com/watch?v=GzAwLI2lnm0',
 'Tunis, Tunisia', 9, NULL
);

SET @r_shak = (SELECT recipe_id FROM recipes WHERE slug='shakshuka-with-feta' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_shak, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_shak;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_shak, 'olive oil', '2', 'tbsp', NULL, 1),
(@r_shak, 'yellow onion', '1/2', 'pc', 'diced', 2),
(@r_shak, 'red bell pepper', '1', 'pc', 'diced', 3),
(@r_shak, 'garlic', '3', 'clove', 'minced', 4),
(@r_shak, 'ground cumin', '1', 'tsp', NULL, 5),
(@r_shak, 'sweet paprika', '1', 'tsp', NULL, 6),
(@r_shak, 'chili flakes', '1/2', 'tsp', 'to taste', 7),
(@r_shak, 'crushed tomatoes', '1', 'can', '400 g', 8),
(@r_shak, 'eggs', '4', 'pc', NULL, 9),
(@r_shak, 'feta cheese', '60', 'g', 'crumbled', 10),
(@r_shak, 'fresh parsley/cilantro', NULL, NULL, 'for garnish', 11),
(@r_shak, 'salt & black pepper', NULL, NULL, 'to taste', 12);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_shak;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_shak,'AROMATICS & SPICES','• Sauté onion + pepper with salt until soft.\n• Add garlic; bloom cumin, paprika, chili in oil 30–45 sec.',1),
(@r_shak,'SIMMER THE SAUCE','• Stir in crushed tomatoes; simmer 8–10 min until thick and bright.\n• Adjust salt/pepper.',2),
(@r_shak,'EGGS & FINISH','• Make 4 wells; crack eggs; cover 5–7 min to jammy.\n• Crumble feta; add herbs; serve with warm bread.',3);



/* ===========================================================
   RECIPE 5: Spicy Pork Bulgogi Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Spicy Pork Bulgogi Bowl',
 'spicy-pork-bulgogi-bowl',
 'Thin-sliced pork shoulder in a gochujang–garlic marinade seared hard for smoky edges. Serve over hot rice with kimchi, cukes and a soft egg. Sweet, spicy, savory—weeknight dynamite.',
 'Korean gochujang pork over rice with crunchy veg.',
 'lunch, korean, bulgogi, pork, gochujang',
 'images/placeholder_pork_bulgogi.jpg',
 '15 min','8 min','23 min',
 0,'easy',TRUE,
 'Short marination, blazing heat, fast assembly.',
 'Whisk gochujang, soy, sugar, garlic and sesame oil. Toss pork; marinate briefly. Sear in batches until caramelized. Build bowls with rice, vegetables and a drizzle of sesame.',
 '• Slice pork shoulder thinly (part-freeze 15 min for easier cuts).\n• Mince garlic; slice scallions; prepare cucumbers + kimchi.',
 '• Whisk marinade: gochujang, soy, sugar, garlic, sesame oil.\n• Toss pork; rest 10–15 min.\n• Sear in batches 60–90 sec until charred at edges.\n• Assemble bowls: rice, pork, cucumbers, kimchi, scallions; add soft egg if you like.',
 '• Use a screaming-hot pan to avoid steaming.\n• Add a touch of butter at the end for gloss (optional).',
 '• Don’t crowd the pan—work in batches.\n• Don’t marinate too long; acids can toughen meat.',
 'https://www.youtube.com/watch?v=Vk4HJ91ctCQ',
 'Seoul, South Korea', 12, NULL
);

SET @r_bulgogi = (SELECT recipe_id FROM recipes WHERE slug='spicy-pork-bulgogi-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_bulgogi, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_bulgogi;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_bulgogi, 'pork shoulder (thin-sliced)', '450', 'g', NULL, 1),
(@r_bulgogi, 'gochujang', '2', 'tbsp', NULL, 2),
(@r_bulgogi, 'soy sauce', '1 1/2', 'tbsp', NULL, 3),
(@r_bulgogi, 'sugar', '2', 'tsp', NULL, 4),
(@r_bulgogi, 'garlic', '3', 'clove', 'minced', 5),
(@r_bulgogi, 'sesame oil', '1', 'tbsp', NULL, 6),
(@r_bulgogi, 'neutral oil', '1', 'tbsp', 'for searing', 7),
(@r_bulgogi, 'steamed rice', '2', 'cup', 'for serving', 8),
(@r_bulgogi, 'kimchi', '1', 'cup', NULL, 9),
(@r_bulgogi, 'cucumber', '1', 'pc', 'sliced', 10),
(@r_bulgogi, 'scallions', '2', 'stalk', 'sliced', 11),
(@r_bulgogi, 'eggs (soft-boiled)', '2', 'pc', 'optional', 12);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_bulgogi,'MARINATE','• Whisk gochujang, soy, sugar, garlic, sesame oil.\n• Toss pork; rest 10–15 min.',1),
(@r_bulgogi,'SEAR','• Heat pan very hot; add oil.\n• Sear pork in batches 60–90 sec until caramelized.',2),
(@r_bulgogi,'ASSEMBLE','• Bowl up rice, pork, cucumbers, kimchi, scallions.\n• Add soft egg; drizzle sesame oil if you like.',3);



/* ===========================================================
   RECIPE 6: Thai Green Curry with Chicken (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Thai Green Curry with Chicken',
 'thai-green-curry-with-chicken',
 'Fragrant green curry paste blooms in coconut cream for a sauce that’s herbaceous and gently spicy. Tender chicken, Thai eggplant (or zucchini) and kaffir lime leaf deliver a deeply aromatic dinner in under 30 minutes.',
 'Aromatic green curry with coconut, chicken and veg.',
 'dinner, thai, green curry, coconut, chicken',
 'images/placeholder_green_curry.jpg',
 '10 min','18 min','28 min',
 0,'medium',TRUE,
 'Bloom curry paste in fat; control thickness with coconut milk and a splash of stock.',
 'Reduce coconut cream until it splits; fry curry paste until shiny and fragrant. Add chicken, vegetables and coconut milk; simmer until tender. Season with fish sauce and sugar; finish with basil.',
 '• Slice chicken; prep Thai eggplant/zucchini; tear kaffir lime leaves.\n• Separate thick coconut cream from thinner milk (if canned).',
 '• Reduce coconut cream until glossy; fry green curry paste 1–2 min.\n• Add chicken; stir to coat; pour in coconut milk + a little stock.\n• Simmer with veg 8–10 min until tender; season with fish sauce + sugar.\n• Finish with Thai basil; serve with jasmine rice.',
 '• Balance salt (fish sauce), sweet (sugar) and heat (curry paste) to your preference.\n• If too thick, add stock; if too thin, simmer uncovered.',
 '• Don’t burn the curry paste—keep it sizzling but controlled.\n• Don’t boil vigorously after adding basil to preserve aroma.',
 'https://www.youtube.com/watch?v=yfMn3ZFJHig',
 'Bangkok, Thailand', 11, NULL
);

SET @r_greencurry = (SELECT recipe_id FROM recipes WHERE slug='thai-green-curry-with-chicken' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_greencurry, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_greencurry;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_greencurry, 'coconut cream', '1/2', 'cup', NULL, 1),
(@r_greencurry, 'green curry paste', '2', 'tbsp', NULL, 2),
(@r_greencurry, 'chicken thigh (sliced)', '400', 'g', NULL, 3),
(@r_greencurry, 'coconut milk', '1', 'can', '≈400 ml', 4),
(@r_greencurry, 'chicken stock', '1/2', 'cup', 'as needed', 5),
(@r_greencurry, 'Thai eggplant or zucchini', '200', 'g', 'chunked', 6),
(@r_greencurry, 'kaffir lime leaves', '3', 'leaf', 'torn', 7),
(@r_greencurry, 'fish sauce', '1–2', 'tbsp', 'to taste', 8),
(@r_greencurry, 'sugar', '1', 'tsp', NULL, 9),
(@r_greencurry, 'Thai basil', NULL, NULL, 'for finish', 10),
(@r_greencurry, 'jasmine rice', NULL, NULL, 'for serving', 11);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_greencurry;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_greencurry,'BLOOM & FRY','• Reduce coconut cream until it splits and looks glossy.\n• Fry green curry paste 1–2 min until fragrant.',1),
(@r_greencurry,'SIMMER','• Add chicken; stir to coat.\n• Pour in coconut milk + a splash of stock; add veg; simmer 8–10 min.',2),
(@r_greencurry,'SEASON & FINISH','• Season with fish sauce + sugar; adjust thickness.\n• Stir in Thai basil; serve with jasmine rice.',3);

/* ===========================================================
   RECIPE 7: Tamagoyaki Breakfast Sando (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Tamagoyaki Breakfast Sando',
 'tamagoyaki-breakfast-sando',
 'Thick, custardy Japanese rolled omelet tucked between soft milk bread with a swipe of Kewpie mayo and a sprinkle of scallions. Sweet–savory, bouncy, and incredibly satisfying for a fast breakfast.',
 'Fluffy Japanese rolled omelet sandwich on milk bread.',
 'breakfast, tamagoyaki, sandwich, japanese, egg',
 'images/placeholder_tamagoyaki_sando.jpg',
 '10 min','8 min','18 min',
 0,'easy',TRUE,
 'Low heat + patient rolling gives you the signature layers.',
 'Beat eggs with sugar, mirin and a touch of soy. Cook in thin layers, rolling each pass to build height. Tuck into soft milk bread with mayo and scallions; slice cleanly.',
 '• Beat eggs with sugar, mirin, soy; strain for extra smoothness.\n• Prep milk bread, Kewpie mayo, scallions.\n• Heat a small rectangular pan (or round) over low.',
 '• Brush pan with oil.\n• Add a thin egg layer; when just set, roll to one side.\n• Oil pan; add more egg, lift the roll so egg flows underneath; roll again.\n• Repeat until thick and bouncy.\n• Spread mayo on bread; add tamagoyaki; sprinkle scallions; press and cut.',
 '• Keep heat low so layers set without browning.\n• Strain eggs to remove bubbles.\n• Square the roll gently with chopsticks for clean edges.',
 '• Don’t rush the roll—raw layers will ooze out.\n• Don’t over-brown; bitterness creeps in.',
 'https://www.youtube.com/watch?v=43Ii7Rqkd7g',
 'Tokyo, Japan', 12, NULL
);

SET @r_tamago = (SELECT recipe_id FROM recipes WHERE slug='tamagoyaki-breakfast-sando' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_tamago, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_tamago;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_tamago, 'eggs', '4', 'pc', NULL, 1),
(@r_tamago, 'sugar', '1', 'tsp', NULL, 2),
(@r_tamago, 'mirin', '1', 'tbsp', NULL, 3),
(@r_tamago, 'soy sauce', '1', 'tsp', NULL, 4),
(@r_tamago, 'neutral oil', '1', 'tbsp', 'for the pan', 5),
(@r_tamago, 'milk bread (shokupan)', '2', 'slice', NULL, 6),
(@r_tamago, 'Kewpie mayonnaise', '1–2', 'tbsp', 'to taste', 7),
(@r_tamago, 'scallions', '1', 'stalk', 'thinly sliced', 8);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_tamago;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_tamago,'MIX & PREP','• Beat eggs with sugar, mirin, soy.\n• Strain mixture; heat pan on low; ready bread + mayo + scallions.',1),
(@r_tamago,'ROLL THE OMELET','• Brush oil; add a thin layer; set softly.\n• Roll; add more egg, lift roll so egg flows beneath; repeat to build height.',2),
(@r_tamago,'ASSEMBLE','• Mayo both bread slices; add omelet; sprinkle scallions.\n• Press gently; cut in half; serve warm.',3);



/* ===========================================================
   RECIPE 8: Mediterranean Chickpea & Feta Salad (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Mediterranean Chickpea & Feta Salad',
 'mediterranean-chickpea-and-feta-salad',
 'A no-cook, ultra-crunchy lunch: chickpeas, crisp cucumbers, tomatoes and peppers tossed in a lemon–oregano vinaigrette, finished with briny feta and herbs. Meal-prep friendly and bright for days.',
 'Zesty chickpea salad with feta, lemon and herbs.',
 'lunch, salad, chickpea, feta, mediterranean',
 'images/placeholder_chickpea_feta_salad.jpg',
 '12 min','0 min','12 min',
 0,'easy',TRUE,
 'Salt your veg lightly first so the dressing clings.',
 'Whisk a sharp lemon–oregano vinaigrette. Toss chickpeas and crunchy veg; finish with feta and herbs. Let it sit a few minutes so flavors marry.',
 '• Rinse + drain chickpeas.\n• Dice cucumber, tomato, bell pepper; slice red onion.\n• Whisk dressing: lemon juice, olive oil, Dijon, garlic, oregano.',
 '• Toss chickpeas + veg with dressing; season.\n• Fold in feta and parsley; add olives if you like.\n• Rest 5–10 min; serve or box for meal prep.',
 '• Pat chickpeas dry for better texture.\n• Add a pinch of sugar if lemons are very tart.',
 '• Don’t crumble feta too fine—leave creamy chunks.\n• Don’t overdress; it should be shiny, not soupy.',
 'https://www.youtube.com/watch?v=NwNvXSNAOFg',
 'Athens, Greece', 10, NULL
);

SET @r_chickpea = (SELECT recipe_id FROM recipes WHERE slug='mediterranean-chickpea-and-feta-salad' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_chickpea, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_chickpea;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_chickpea, 'chickpeas (canned), rinsed', '1', 'can', '≈400 g', 1),
(@r_chickpea, 'cucumber', '1', 'pc', 'diced', 2),
(@r_chickpea, 'tomatoes', '2', 'pc', 'diced', 3),
(@r_chickpea, 'red bell pepper', '1/2', 'pc', 'diced', 4),
(@r_chickpea, 'red onion', '1/4', 'pc', 'thinly sliced', 5),
(@r_chickpea, 'kalamata olives', '1/2', 'cup', 'pitted, optional', 6),
(@r_chickpea, 'feta cheese', '80', 'g', 'crumbled', 7),
(@r_chickpea, 'parsley', NULL, NULL, 'chopped, to taste', 8),
(@r_chickpea, 'lemon juice', '2', 'tbsp', NULL, 9),
(@r_chickpea, 'olive oil', '3', 'tbsp', NULL, 10),
(@r_chickpea, 'Dijon mustard', '1', 'tsp', NULL, 11),
(@r_chickpea, 'garlic', '1', 'clove', 'grated', 12),
(@r_chickpea, 'dried oregano', '1', 'tsp', NULL, 13),
(@r_chickpea, 'salt & black pepper', NULL, NULL, 'to taste', 14);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_chickpea,'DRESSING','• Whisk lemon juice + Dijon + garlic + oregano.\n• Stream in olive oil; season.',1),
(@r_chickpea,'TOSS & REST','• Combine chickpeas + veg; add dressing; toss.\n• Fold in feta + parsley; rest 5–10 min; serve.',2),
(@r_chickpea,'MEAL PREP','• Stores 2–3 days chilled.\n• Refresh with a squeeze of lemon before eating.',3);



/* ===========================================================
   RECIPE 9: Moroccan Chicken Tagine with Apricots (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Moroccan Chicken Tagine with Apricots',
 'moroccan-chicken-tagine-with-apricots',
 'Braised chicken scented with ras el hanout, ginger and saffron, simmered low with onions until tender and glossy. Sweet dried apricots and toasted almonds finish a sauce that’s spiced, savory and gently sweet—perfect over couscous.',
 'Fragrant Moroccan chicken braise with apricots and almonds.',
 'dinner, moroccan, tagine, chicken, apricot',
 'images/placeholder_moroccan_tagine.jpg',
 '15 min','45 min','60 min',
 0,'medium',TRUE,
 'Bloom spices in oil, then braise gently—low and slow.',
 'Season chicken and brown lightly. Sweat onions with spices until jammy; add broth and saffron; braise until tender. Finish with apricots and almonds; shower with herbs.',
 '• Mix spice base: ras el hanout, ground ginger, turmeric, cinnamon.\n• Bloom saffron in warm stock.\n• Slice onions; chop herbs; ready dried apricots and almonds.',
 '• Brown chicken in oil; remove.\n• Sweat onions; add garlic + spices until fragrant.\n• Return chicken; add saffron stock; cover and braise 30–35 min.\n• Stir in apricots; simmer 5–8 min; adjust seasoning.\n• Top with toasted almonds + herbs; serve with couscous.',
 '• Use bone-in thighs for maximum flavor.\n• A touch of honey balances acidity if needed.',
 '• Don’t scorch the spices—keep heat moderate.\n• Don’t skip resting 5 min before serving; juices settle.',
 'https://www.youtube.com/watch?v=ZQjqx_JDqb4',
 'Marrakesh, Morocco', 8, NULL
);

SET @r_tagine = (SELECT recipe_id FROM recipes WHERE slug='moroccan-chicken-tagine-with-apricots' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_tagine, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_tagine;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_tagine, 'chicken thighs (bone-in, skin-on)', '1', 'kg', NULL, 1),
(@r_tagine, 'olive oil', '2', 'tbsp', NULL, 2),
(@r_tagine, 'yellow onions', '2', 'pc', 'sliced', 3),
(@r_tagine, 'garlic', '3', 'clove', 'minced', 4),
(@r_tagine, 'ras el hanout', '2', 'tsp', NULL, 5),
(@r_tagine, 'ground ginger', '1', 'tsp', NULL, 6),
(@r_tagine, 'turmeric', '1/2', 'tsp', NULL, 7),
(@r_tagine, 'cinnamon', '1/4', 'tsp', NULL, 8),
(@r_tagine, 'chicken stock (warm, with saffron)', '2', 'cup', NULL, 9),
(@r_tagine, 'saffron', '1', 'pinch', 'bloomed in stock', 10),
(@r_tagine, 'dried apricots', '3/4', 'cup', 'halved', 11),
(@r_tagine, 'toasted almonds', '1/3', 'cup', 'sliced or slivered', 12),
(@r_tagine, 'fresh cilantro/parsley', NULL, NULL, 'for garnish', 13),
(@r_tagine, 'salt & black pepper', NULL, NULL, 'to taste', 14);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_tagine;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_tagine,'SPICES & BASE','• Bloom saffron in warm stock.\n• Mix ras el hanout + ginger + turmeric + cinnamon.',1),
(@r_tagine,'BRAISE','• Brown chicken; sweat onions; add garlic + spices.\n• Return chicken; pour saffron stock; cover and braise until tender.',2),
(@r_tagine,'FINISH','• Stir in apricots; simmer 5–8 min.\n• Season; top with almonds + herbs; serve with couscous.',3);

/* ===========================================================
   RECIPE 10: Banana-Nut Overnight Oats (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Banana-Nut Overnight Oats',
 'banana-nut-overnight-oats',
 'Creamy, no-cook oats soaked overnight with yogurt and mashed banana. Toasted nuts add crunch while cinnamon and vanilla make it taste like banana bread. Perfect grab-and-go breakfast.',
 'Overnight oats with banana, yogurt and toasted nuts.',
 'breakfast, oats, banana, yogurt, make-ahead',
 'images/placeholder_overnight_oats.jpg',
 '8 min','0 min','8 min (+overnight)',
 0,'easy',TRUE,
 'Stir, chill overnight, top and eat—no stove required.',
 'Mix oats, milk and yogurt with mashed banana, vanilla and cinnamon. Chill overnight until thick and creamy. Top with toasted walnuts, extra banana and honey.',
 '• Mash a ripe banana.\n• Measure rolled oats, milk, yogurt.\n• Toast walnuts lightly; let cool.',
 '• Stir oats + milk + yogurt + mashed banana + vanilla + cinnamon.\n• Divide into jars; chill overnight (≥6–8h).\n• Next morning: loosen with a splash of milk; top with walnuts, sliced banana, honey.',
 '• Use ripe bananas for natural sweetness.\n• Toast nuts for deeper flavor.\n• Make 2–3 jars at once for the week.',
 '• Don’t use instant oats if you want more texture.\n• Don’t skip chilling—hydration is key to creaminess.',
 'https://www.youtube.com/watch?v=AsQc5xhOmFc',
 'Portland, USA', 9, NULL
);

SET @r_oats = (SELECT recipe_id FROM recipes WHERE slug='banana-nut-overnight-oats' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_oats, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_oats;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_oats, 'rolled oats', '1', 'cup', NULL, 1),
(@r_oats, 'milk (dairy or plant)', '1', 'cup', NULL, 2),
(@r_oats, 'plain yogurt', '1/2', 'cup', NULL, 3),
(@r_oats, 'ripe banana', '1', 'pc', 'mashed + extra slices for topping', 4),
(@r_oats, 'vanilla extract', '1', 'tsp', NULL, 5),
(@r_oats, 'ground cinnamon', '1/2', 'tsp', NULL, 6),
(@r_oats, 'walnuts', '1/3', 'cup', 'toasted, chopped', 7),
(@r_oats, 'honey or maple syrup', '1–2', 'tbsp', 'to taste', 8),
(@r_oats, 'pinch of salt', NULL, NULL, 'optional, balances sweetness', 9);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_oats;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_oats,'MIX BASE','• Mash banana.\n• Stir oats + milk + yogurt + vanilla + cinnamon + pinch of salt.',1),
(@r_oats,'CHILL','• Portion into jars; cover.\n• Refrigerate overnight (6–8h) until thick and creamy.',2),
(@r_oats,'TOP & SERVE','• Loosen with milk if needed.\n• Top with walnuts, banana slices, drizzle honey.',3);



/* ===========================================================
   RECIPE 11: Chipotle Chicken Burrito Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Chipotle Chicken Burrito Bowl',
 'chipotle-chicken-burrito-bowl',
 'Smoky chipotle chicken over cilantro-lime rice with sweet corn, black beans and crisp veggies. A cool yogurt-lime sauce ties everything together—fast, colorful lunch that meal-preps like a champ.',
 'Smoky chipotle chicken with cilantro-lime rice and toppings.',
 'lunch, burrito bowl, chicken, chipotle, meal prep',
 'images/placeholder_burrito_bowl.jpg',
 '15 min','15 min','30 min',
 0,'easy',TRUE,
 'Marinate briefly, sear hot, and build bowls with contrasting textures.',
 'Whisk a quick chipotle marinade, sear chicken until charred at the edges, then slice. Pile over cilantro-lime rice with beans, corn, lettuce and pico; drizzle yogurt-lime sauce.',
 '• Cook rice; toss hot rice with lime juice + zest + chopped cilantro.\n• Whisk marinade: chipotle in adobo, garlic, cumin, lime, oil.\n• Stir yogurt-lime sauce separately.',
 '• Sear marinated chicken 3–4 min/side; rest; slice.\n• Assemble bowls: rice, chicken, black beans, corn, lettuce, pico, avocado.\n• Spoon yogurt-lime sauce; finish with cilantro.',
 '• Quick-marinate 10–15 min still works.\n• Char edges for smoky flavor.\n• Keep extra sauce for tomorrow’s bowl.',
 '• Don’t crowd the pan or chicken will steam.\n• Don’t overdress—keep it bright, not heavy.',
 'https://www.youtube.com/watch?v=PtTrjiLpTSc',
 'Austin, USA', 10, NULL
);

SET @r_chipotle = (SELECT recipe_id FROM recipes WHERE slug='chipotle-chicken-burrito-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_chipotle, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_chipotle;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_chipotle, 'chicken thigh (boneless)', '500', 'g', 'marinate + sear', 1),
(@r_chipotle, 'chipotle in adobo', '1–2', 'tbsp', 'minced', 2),
(@r_chipotle, 'garlic', '3', 'clove', 'minced', 3),
(@r_chipotle, 'ground cumin', '1', 'tsp', NULL, 4),
(@r_chipotle, 'lime juice', '2', 'tbsp', NULL, 5),
(@r_chipotle, 'olive/neutral oil', '1', 'tbsp', NULL, 6),
(@r_chipotle, 'cooked white rice', '2', 'cup', 'tossed with lime zest + cilantro', 7),
(@r_chipotle, 'black beans (rinsed)', '1', 'cup', NULL, 8),
(@r_chipotle, 'sweet corn kernels', '1', 'cup', NULL, 9),
(@r_chipotle, 'romaine lettuce', '2', 'cup', 'shredded', 10),
(@r_chipotle, 'pico de gallo', '1/2', 'cup', NULL, 11),
(@r_chipotle, 'avocado', '1', 'pc', 'sliced', 12),
(@r_chipotle, 'plain yogurt', '1/2', 'cup', 'for sauce w/ lime + salt', 13),
(@r_chipotle, 'fresh cilantro', NULL, NULL, 'for garnish', 14),
(@r_chipotle, 'salt & black pepper', NULL, NULL, 'to taste', 15);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_chipotle;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_chipotle,'MARINATE','• Whisk chipotle + garlic + cumin + lime + oil + salt.\n• Toss chicken; rest 10–20 min.',1),
(@r_chipotle,'SEAR','• Heat pan hot; add oil.\n• Sear chicken 3–4 min/side until charred + cooked; rest and slice.',2),
(@r_chipotle,'ASSEMBLE','• Bowl: cilantro-lime rice, chicken, beans, corn, lettuce, pico, avocado.\n• Drizzle yogurt-lime sauce; garnish cilantro.',3);



/* ===========================================================
   RECIPE 12: Butter Chicken (Murgh Makhani) (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Butter Chicken (Murgh Makhani)',
 'butter-chicken-murgh-makhani',
 'Tender yogurt-marinated chicken in a velvety tomato-butter sauce perfumed with garam masala, kasuri methi and ginger. Rich, mildly spiced and perfectly scoopable with naan or rice.',
 'Creamy tomato-butter chicken with warm spices.',
 'dinner, indian, butter chicken, curry',
 'images/placeholder_butter_chicken.jpg',
 '20 min','25 min','45 min',
 0,'medium',TRUE,
 'Marinate chicken for tenderness, then simmer in a silky, slightly sweet tomato-butter sauce.',
 'Marinate chicken with yogurt, spices and ginger–garlic. Sear until lightly charred. Simmer in a smooth tomato base finished with butter and cream; crush in kasuri methi.',
 '• Whisk marinade: yogurt, ginger–garlic paste, garam masala, chili, turmeric, salt.\n• Toss chicken; rest 20–30 min (longer if time allows).\n• Prep sauce aromatics: onion, tomato purée, butter, cream.',
 '• Sear chicken in a film of oil until lightly charred; remove.\n• Sauté onion; add ginger–garlic; spices; then tomato purée; simmer.\n• Return chicken; add butter + cream; crush kasuri methi; simmer to coat.',
 '• Blend the sauce smooth for restaurant-style texture.\n• Finish with a knob of cold butter for sheen.\n• A pinch of sugar balances acidity if needed.',
 '• Don’t burn spices—keep them fragrant, not dark.\n• Don’t overreduce; the sauce should be pourable and creamy.',
 'https://www.youtube.com/watch?v=6QrNfWjAPfc',
 'Delhi, India', 10, NULL
);

SET @r_butter = (SELECT recipe_id FROM recipes WHERE slug='butter-chicken-murgh-makhani' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_butter, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_butter;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_butter, 'chicken thigh (boneless)', '700', 'g', 'bite-size', 1),
(@r_butter, 'plain yogurt', '2/3', 'cup', 'for marinade', 2),
(@r_butter, 'ginger–garlic paste', '1 1/2', 'tbsp', NULL, 3),
(@r_butter, 'garam masala', '2', 'tsp', NULL, 4),
(@r_butter, 'kashmiri chili powder', '1', 'tsp', 'or mild chili', 5),
(@r_butter, 'turmeric', '1/2', 'tsp', NULL, 6),
(@r_butter, 'neutral oil', '1', 'tbsp', 'for searing', 7),
(@r_butter, 'unsalted butter', '3', 'tbsp', 'divided', 8),
(@r_butter, 'yellow onion', '1', 'pc', 'finely diced', 9),
(@r_butter, 'tomato purée (passata)', '1 1/2', 'cup', NULL, 10),
(@r_butter, 'heavy cream', '1/2', 'cup', NULL, 11),
(@r_butter, 'kasuri methi (dried fenugreek leaves)', '1', 'tsp', 'crushed', 12),
(@r_butter, 'sugar', '1', 'tsp', 'optional, to balance', 13),
(@r_butter, 'salt', NULL, NULL, 'to taste', 14),
(@r_butter, 'fresh cilantro', NULL, NULL, 'for garnish', 15),
(@r_butter, 'naan or basmati rice', NULL, NULL, 'for serving', 16);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_butter;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_butter,'MARINATE','• Whisk yogurt + ginger–garlic + garam masala + chili + turmeric + salt.\n• Toss chicken; rest 20–30 min (or overnight).',1),
(@r_butter,'SEAR & BASE','• Sear chicken until lightly charred; remove.\n• Sauté onion in butter; add ginger–garlic; bloom spices briefly.',2),
(@r_butter,'SIMMER & FINISH','• Stir in tomato purée; simmer 5–8 min.\n• Return chicken; add butter + cream; crush kasuri methi.\n• Adjust salt/sugar; sauce should be silky.',3);

/* ===========================================================
   RECIPE 13: Savory Miso Oat Congee (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Savory Miso Oat Congee',
 'savory-miso-oat-congee',
 'Comforting, savory “congee” made from rolled oats simmered with ginger and scallions, then finished with white miso for deep umami. A soft egg, sesame oil, and crunchy toppings turn it into a complete, cozy breakfast.',
 'Cozy miso-ginger oat congee with egg and scallions.',
 'breakfast, oats, miso, congee, savory',
 'images/placeholder_miso_oat_congee.jpg',
 '5 min','12 min','17 min',
 0,'easy',TRUE,
 'Rinse oats briefly to remove chalkiness; miso goes in off the heat to keep it fragrant.',
 'Simmer oats with water, ginger and scallion whites until creamy. Off heat, whisk in miso. Ladle into bowls and top with soft egg, sesame oil, scallion greens and crunchy bits.',
 '• Rinse rolled oats quickly; drain well.\n• Slice scallions (whites/greens separated); grate ginger.\n• Ready toppings: soft egg, sesame oil, chili crisp, toasted seeds.',
 '• Simmer oats + water + ginger + scallion whites 10–12 min, stirring.\n• Off heat: whisk in miso until smooth.\n• Bowl up; top with egg, scallion greens, sesame oil, chili crisp, seeds.',
 '• Add a splash of stock for extra savoriness.\n• Stir often for creaminess without sticking.',
 '• Don’t boil miso—add off heat to preserve aroma.\n• Don’t skip salt check; miso salinity varies.',
 'https://www.youtube.com/watch?v=_b6WFymVeq0',
 'Sapporo, Japan', 9, NULL
);

SET @r_misooats = (SELECT recipe_id FROM recipes WHERE slug='savory-miso-oat-congee' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_misooats, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_misooats;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_misooats, 'rolled oats', '1', 'cup', NULL, 1),
(@r_misooats, 'water or light stock', '3', 'cup', NULL, 2),
(@r_misooats, 'ginger', '1', 'tbsp', 'finely grated', 3),
(@r_misooats, 'scallions (whites, greens separated)', '3', 'stalk', NULL, 4),
(@r_misooats, 'white miso', '1 1/2', 'tbsp', NULL, 5),
(@r_misooats, 'eggs (soft-boiled)', '2', 'pc', 'for topping', 6),
(@r_misooats, 'sesame oil', '1', 'tbsp', 'for finish', 7),
(@r_misooats, 'chili crisp', '1', 'tbsp', 'optional', 8),
(@r_misooats, 'toasted seeds (sesame/pumpkin)', '2', 'tbsp', 'for crunch', 9),
(@r_misooats, 'salt & white pepper', NULL, NULL, 'to taste', 10);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_misooats;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_misooats,'PREP','• Rinse oats; slice scallions; grate ginger.\n• Boil eggs to soft (6–7 min); peel.',1),
(@r_misooats,'SIMMER','• Oats + water + ginger + scallion whites -> simmer 10–12 min, stirring until creamy.\n• Season lightly.',2),
(@r_misooats,'FINISH','• Off heat whisk in miso.\n• Bowl; top egg, scallion greens, sesame oil, chili crisp, seeds.',3);



/* ===========================================================
   RECIPE 14: Grilled Halloumi Pita with Tzatziki (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Grilled Halloumi Pita with Tzatziki',
 'grilled-halloumi-pita-with-tzatziki',
 'Squeaky, golden-seared halloumi tucked into warm pita with juicy tomatoes, cucumbers, herbs and a cool garlicky tzatziki. Bright, filling, and meatless—perfect lunch in minutes.',
 'Halloumi pita with fresh veg and creamy tzatziki.',
 'lunch, vegetarian, halloumi, pita, tzatziki',
 'images/placeholder_halloumi_pita.jpg',
 '12 min','8 min','20 min',
 0,'easy',TRUE,
 'Pat halloumi dry before searing so it browns, not steams.',
 'Whisk a quick tzatziki, sear halloumi until deeply golden, then stuff warm pitas with veg, herbs and plenty of sauce.',
 '• Pat halloumi dry; slice 1 cm thick.\n• Dice tomatoes + cucumber; slice red onion; chop dill/mint.\n• Mix tzatziki: yogurt, grated cucumber, garlic, lemon, olive oil, salt.',
 '• Sear halloumi 2–3 min/side until golden.\n• Warm pitas; spread tzatziki; add halloumi, tomatoes, cucumber, onion, herbs.\n• Squeeze lemon; wrap and serve.',
 '• Salt tomatoes lightly first so juices concentrate.\n• A pinch of sumac adds citrusy pop.',
 '• Don’t overcrowd the pan—halloumi needs contact to brown.\n• Don’t skip pat-drying; moisture prevents crust.',
 'https://www.youtube.com/watch?v=K96wtA01J0k',
 'Thessaloniki, Greece', 10, NULL
);

SET @r_halloumi = (SELECT recipe_id FROM recipes WHERE slug='grilled-halloumi-pita-with-tzatziki' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_halloumi, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_halloumi;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_halloumi, 'halloumi cheese', '250', 'g', 'sliced 1 cm', 1),
(@r_halloumi, 'pita bread', '2', 'pc', 'warmed', 2),
(@r_halloumi, 'tomatoes', '2', 'pc', 'diced', 3),
(@r_halloumi, 'cucumber', '1/2', 'pc', 'diced', 4),
(@r_halloumi, 'red onion', '1/4', 'pc', 'thinly sliced', 5),
(@r_halloumi, 'fresh dill', '1', 'tbsp', 'chopped', 6),
(@r_halloumi, 'fresh mint', '1', 'tbsp', 'chopped', 7),
(@r_halloumi, 'Greek yogurt', '3/4', 'cup', 'for tzatziki', 8),
(@r_halloumi, 'garlic', '1', 'clove', 'grated', 9),
(@r_halloumi, 'lemon juice', '1', 'tbsp', NULL, 10),
(@r_halloumi, 'olive oil', '1', 'tbsp', 'plus more to sear', 11),
(@r_halloumi, 'grated cucumber (squeezed dry)', '1/2', 'cup', 'for tzatziki', 12),
(@r_halloumi, 'sumac', '1/2', 'tsp', 'optional', 13),
(@r_halloumi, 'salt & black pepper', NULL, NULL, 'to taste', 14);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_halloumi,'TZATZIKI','• Mix yogurt + grated cucumber + garlic + lemon + olive oil + salt.\n• Chill while you sear cheese.',1),
(@r_halloumi,'SEAR & WARM','• Sear halloumi 2–3 min/side until golden.\n• Warm pitas briefly.',2),
(@r_halloumi,'ASSEMBLE','• Spread tzatziki; add halloumi, tomatoes, cucumber, onion, herbs.\n• Sprinkle sumac; squeeze lemon; serve.',3);



/* ===========================================================
   RECIPE 15: Garlicky Shrimp Scampi Linguine (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Garlicky Shrimp Scampi Linguine',
 'garlicky-shrimp-scampi-linguine',
 'Buttery, lemony shrimp scampi tossed with al dente linguine, loads of garlic and a splash of white wine. Bright, fast, and restaurant-level weeknight dinner.',
 'Linguine with lemon–garlic shrimp and white wine butter sauce.',
 'dinner, pasta, shrimp scampi, lemon, quick',
 'images/placeholder_shrimp_scampi.jpg',
 '10 min','12 min','22 min',
 0,'easy',TRUE,
 'Pull pasta just shy of al dente and finish in the pan so it drinks up the sauce.',
 'Sizzle garlic in butter and oil, bloom chili, then add shrimp and white wine; reduce to a glossy sauce with lemon. Toss in linguine and parsley; finish with a knob of butter.',
 '• Thaw/pat dry shrimp; season lightly with salt.\n• Boil linguine in salted water; reserve 1 cup pasta water.\n• Mince garlic; chop parsley; cut lemon.',
 '• Sauté garlic in butter + oil; add chili flakes.\n• Add shrimp; cook just until pink; remove.\n• Deglaze with white wine + lemon juice; reduce.\n• Toss in pasta + splash of pasta water to emulsify; return shrimp; finish with butter + parsley.',
 '• Emulsify with starchy pasta water for a silky sauce.\n• Zest half the lemon for extra fragrance.',
 '• Don’t overcook shrimp—turn rubbery fast.\n• Don’t drown in cheese; a light shower is enough.',
 'https://www.youtube.com/watch?v=FmrvfaoOX8A',
 'Naples, Italy', 9, NULL
);

SET @r_scampi = (SELECT recipe_id FROM recipes WHERE slug='garlicky-shrimp-scampi-linguine' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_scampi, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_scampi;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_scampi, 'linguine', '300', 'g', NULL, 1),
(@r_scampi, 'shrimp (peeled, deveined)', '400', 'g', NULL, 2),
(@r_scampi, 'unsalted butter', '3', 'tbsp', 'divided', 3),
(@r_scampi, 'olive oil', '1', 'tbsp', NULL, 4),
(@r_scampi, 'garlic', '5', 'clove', 'thinly sliced', 5),
(@r_scampi, 'red chili flakes', '1/2', 'tsp', 'to taste', 6),
(@r_scampi, 'dry white wine', '1/2', 'cup', NULL, 7),
(@r_scampi, 'lemon juice', '2', 'tbsp', NULL, 8),
(@r_scampi, 'lemon zest', '1', 'tsp', 'optional', 9),
(@r_scampi, 'parsley', '2', 'tbsp', 'chopped', 10),
(@r_scampi, 'pasta cooking water', '1/2', 'cup', 'as needed', 11),
(@r_scampi, 'salt & black pepper', NULL, NULL, 'to taste', 12);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_scampi;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_scampi,'PASTA & PREP','• Boil linguine in salted water; save 1 cup water.\n• Pat shrimp dry; mince garlic; chop parsley; zest lemon.',1),
(@r_scampi,'SAUCE BASE','• Butter + oil; gently sizzle garlic; add chili.\n• Add shrimp; cook just until pink; remove.',2),
(@r_scampi,'EMULSIFY & TOSS','• Deglaze with wine + lemon; reduce.\n• Toss in pasta + splash of pasta water to emulsify; return shrimp.\n• Finish with butter + parsley; season and serve.',3);

/* ===========================================================
   SEAFOOD 1: Smoked Salmon Avocado Toast w/ Poached Egg (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Smoked Salmon Avocado Toast with Poached Egg',
 'smoked-salmon-avocado-toast-poached-egg',
 'Creamy avocado smashed on crisp toast, topped with silky smoked salmon and a jammy poached egg. Briny capers, lemon, and dill keep it bright—protein-packed breakfast in minutes.',
 'Avocado toast with smoked salmon, poached egg, capers and dill.',
 'breakfast, smoked salmon, avocado toast, poached egg',
 'images/placeholder_salmon_avotoast.jpg',
 '8 min','6 min','14 min',
 0,'easy',TRUE,
 'Toast + smash + poach: build layers for texture and brightness.',
 'Toast bread; smash avocado with lemon and salt. Poach eggs until whites set. Layer avocado, smoked salmon, capers, dill; crown with egg and a crack of pepper.',
 '• Bring a small pot of water to a bare simmer; add a splash of vinegar.\n• Toast sourdough; slice avocado; cut lemon; pick dill; drain capers.',
 '• Smash avocado with lemon juice + salt.\n• Swirl water; crack egg into center; poach ~3 min to jammy.\n• Spread avocado; add smoked salmon, capers, dill; top with egg; pepper + chili flakes if you like.',
 '• Dry capers on a paper towel for extra pop.\n• Warm plates so toast stays crisp.',
 '• Don’t boil vigorously when poaching—whites will fray.\n• Don’t oversalt—salmon and capers are already salty.',
 'https://www.youtube.com/watch?v=jqzF2AgQmoI',
 'Copenhagen, Denmark', 10, NULL
);

SET @r_salmon_toast = (SELECT recipe_id FROM recipes WHERE slug='smoked-salmon-avocado-toast-poached-egg' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_salmon_toast, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_salmon_toast;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_salmon_toast, 'sourdough bread', '2', 'slice', 'toasted', 1),
(@r_salmon_toast, 'avocado', '1', 'pc', 'ripe, smashed', 2),
(@r_salmon_toast, 'lemon juice', '1', 'tbsp', NULL, 3),
(@r_salmon_toast, 'smoked salmon', '80', 'g', 'sliced', 4),
(@r_salmon_toast, 'eggs', '2', 'pc', 'poached', 5),
(@r_salmon_toast, 'capers', '2', 'tsp', 'drained', 6),
(@r_salmon_toast, 'fresh dill', '1', 'tbsp', 'chopped', 7),
(@r_salmon_toast, 'chili flakes', '1/4', 'tsp', 'optional', 8),
(@r_salmon_toast, 'salt & black pepper', NULL, NULL, 'to taste', 9);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_salmon_toast,'PREP','• Bare simmer a small pot of water + splash vinegar.\n• Toast bread; smash avocado with lemon + salt; pick dill; drain capers.',1),
(@r_salmon_toast,'POACH & BUILD','• Swirl water; poach eggs ~3 min (jammy).\n• Spread avocado on toast; layer salmon, capers, dill.\n• Top with egg; finish with pepper + chili flakes.',2),
(@r_salmon_toast,'SERVE','• Plate warm; add extra lemon wedge if desired.',3);



/* ===========================================================
   SEAFOOD 2: Ahi Tuna Poke Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Ahi Tuna Poke Bowl',
 'ahi-tuna-poke-bowl',
 'Sushi-grade ahi tuna dressed in a soy–sesame marinade over warm rice with avocado, cucumber, edamame and scallions. Clean, fresh, and incredibly satisfying for lunch.',
 'Hawaiian-style tuna poke over rice with crisp veggies.',
 'lunch, poke, tuna, hawaiian, rice bowl',
 'images/placeholder_tuna_poke.jpg',
 '12 min','0 min','12 min',
 0,'easy',TRUE,
 'Use very fresh, sushi-grade tuna; keep everything cold.',
 'Cube tuna; toss with soy, sesame oil, rice vinegar and a touch of honey. Build bowls with rice and crisp veggies; finish with furikake and scallions.',
 '• Chill a mixing bowl; cube sushi-grade tuna.\n• Slice cucumber + avocado; thaw/rinse edamame; slice scallions.\n• Whisk marinade: soy, sesame oil, rice vinegar, honey, chili.',
 '• Toss tuna with marinade; add sesame seeds.\n• Assemble bowls: rice, tuna, cucumber, avocado, edamame.\n• Sprinkle furikake + scallions; serve immediately.',
 '• Pat tuna dry for clean cuts.\n• Keep rice warm and toppings cold for contrast.',
 '• Don’t overmarinate—acids change texture fast (2–5 min is enough).\n• Don’t use non-sushi-grade fish.',
 'https://www.youtube.com/watch?v=4aIWDRtZtRM',
 'Honolulu, Hawaii', 12, NULL
);

SET @r_poke = (SELECT recipe_id FROM recipes WHERE slug='ahi-tuna-poke-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_poke, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_poke;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_poke, 'sushi-grade ahi tuna', '350', 'g', 'cubed 1.5 cm', 1),
(@r_poke, 'soy sauce', '2', 'tbsp', NULL, 2),
(@r_poke, 'toasted sesame oil', '1', 'tbsp', NULL, 3),
(@r_poke, 'rice vinegar', '1', 'tbsp', NULL, 4),
(@r_poke, 'honey or sugar', '1', 'tsp', NULL, 5),
(@r_poke, 'chili flakes or sriracha', '1/2', 'tsp', 'to taste', 6),
(@r_poke, 'sesame seeds', '1', 'tbsp', 'white/black mixed', 7),
(@r_poke, 'steamed short-grain rice', '2', 'cup', 'warm', 8),
(@r_poke, 'cucumber', '1/2', 'pc', 'thinly sliced', 9),
(@r_poke, 'avocado', '1', 'pc', 'sliced', 10),
(@r_poke, 'edamame (shelled)', '1', 'cup', 'thawed', 11),
(@r_poke, 'scallions', '2', 'stalk', 'sliced', 12),
(@r_poke, 'furikake', '1', 'tbsp', 'for finish', 13);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_poke;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_poke,'MARINADE','• Whisk soy + sesame oil + rice vinegar + honey + chili.\n• Chill briefly.',1),
(@r_poke,'TOSS & BUILD','• Toss tuna + sesame seeds with marinade (2–5 min).\n• Bowl: warm rice, tuna, cucumber, avocado, edamame.\n• Finish furikake + scallions.',2),
(@r_poke,'SERVE','• Eat immediately for best texture.',3);



/* ===========================================================
   SEAFOOD 3: Lemon-Caper Butter Baked Cod (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Lemon-Caper Butter Baked Cod',
 'lemon-caper-butter-baked-cod',
 'Flaky white cod baked in a bright lemon–capers–butter pan sauce with garlic and parsley. Simple technique, restaurant-level results—serve with roasted potatoes or greens.',
 'Oven-baked cod with lemon, capers, garlic butter.',
 'dinner, cod, baked fish, lemon caper',
 'images/placeholder_baked_cod.jpg',
 '8 min','14 min','22 min',
 0,'easy',TRUE,
 'High heat + quick bake keeps cod moist; sauce builds right in the pan.',
 'Nestle cod in a small baking dish; dot with butter, capers, garlic and lemon. Bake until just flaky; baste with the buttery juices and shower with parsley.',
 '• Preheat oven to 220°C (425°F).\n• Pat-dry cod; cut lemon into slices + wedges; mince garlic; chop parsley.',
 '• Arrange cod in a small dish; season salt/pepper.\n• Scatter garlic + capers; dot butter; add lemon slices.\n• Bake 12–14 min until flaky; baste with pan juices.\n• Squeeze fresh lemon; sprinkle parsley.',
 '• Use a tight-fitting dish so butter doesn’t burn.\n• Pull fish at 50–52°C internal for perfect flake (if using a thermometer).',
 '• Don’t overbake—cod dries quickly.\n• Don’t skip pat-drying; moisture prevents browning at the edges.',
 'https://www.youtube.com/watch?v=NoMBecQZhto',
 'Lisbon, Portugal', 9, NULL
);

SET @r_cod = (SELECT recipe_id FROM recipes WHERE slug='lemon-caper-butter-baked-cod' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_cod, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_cod;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_cod, 'cod fillets', '600', 'g', '4 pieces', 1),
(@r_cod, 'unsalted butter', '3', 'tbsp', 'cubed', 2),
(@r_cod, 'garlic', '3', 'clove', 'minced', 3),
(@r_cod, 'capers', '1 1/2', 'tbsp', 'drained', 4),
(@r_cod, 'lemon', '1', 'pc', 'slices + wedges', 5),
(@r_cod, 'olive oil', '1', 'tbsp', 'optional drizzle', 6),
(@r_cod, 'fresh parsley', '2', 'tbsp', 'chopped', 7),
(@r_cod, 'salt & black pepper', NULL, NULL, 'to taste', 8);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_cod;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_cod,'PREHEAT & PREP','• Heat oven to 220°C.\n• Pat-dry cod; slice lemon; mince garlic; chop parsley.',1),
(@r_cod,'BAKE','• Season cod; add garlic + capers; dot butter + lemon slices.\n• Bake 12–14 min until cod flakes easily; baste with pan juices.',2),
(@r_cod,'FINISH','• Squeeze lemon; sprinkle parsley; serve hot.',3);


/* ===========================================================
   RECIPE 16: Blueberry Lemon Ricotta Pancakes (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Blueberry Lemon Ricotta Pancakes',
 'blueberry-lemon-ricotta-pancakes',
 'Extra-fluffy pancakes thanks to ricotta and whipped egg whites, studded with juicy blueberries and bright lemon zest. Golden outside, custardy inside—weekend café vibes at home.',
 'Fluffy ricotta pancakes with blueberries and lemon zest.',
 'breakfast, pancakes, ricotta, blueberry, lemon',
 'images/placeholder_ricotta_pancakes.jpg',
 '12 min','12 min','24 min',
 0,'easy',TRUE,
 'Separate eggs: fold whipped whites in last for cloud-like texture.',
 'Make a quick batter with ricotta, yolks, milk and lemon. Fold in dry mix and whipped whites; cook gently; serve with butter and maple.',
 '• Separate eggs; whip whites to soft peaks.\n• Zest lemon; rinse + pat dry blueberries.\n• Whisk dry mix: flour, baking powder, salt.',
 '• Whisk ricotta + yolks + milk + lemon zest + vanilla.\n• Fold in dry mix, then gently fold whipped whites + blueberries.\n• Cook 2–3 min/side on medium-low until golden and set.',
 '• Wipe pan between batches and add a thin film of butter.\n• If batter thickens, splash a bit more milk.',
 '• Don’t overmix after adding whites—keep air for fluff.\n• Don’t cook too hot—the outside burns before center sets.',
 'https://www.youtube.com/watch?v=iSUIRCa1nwk',
 'Melbourne, Australia', 10, NULL
);

SET @r_ricotta = (SELECT recipe_id FROM recipes WHERE slug='blueberry-lemon-ricotta-pancakes' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_ricotta, @cat_breakfast);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_ricotta;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_ricotta, 'ricotta cheese', '3/4', 'cup', NULL, 1),
(@r_ricotta, 'eggs (separated)', '2', 'pc', 'whites whipped', 2),
(@r_ricotta, 'milk', '1/2', 'cup', NULL, 3),
(@r_ricotta, 'all-purpose flour', '1', 'cup', NULL, 4),
(@r_ricotta, 'baking powder', '1 1/2', 'tsp', NULL, 5),
(@r_ricotta, 'salt', '1/4', 'tsp', NULL, 6),
(@r_ricotta, 'lemon zest', '1', 'tbsp', NULL, 7),
(@r_ricotta, 'vanilla extract', '1', 'tsp', NULL, 8),
(@r_ricotta, 'blueberries', '1', 'cup', 'patted dry', 9),
(@r_ricotta, 'unsalted butter', '2', 'tbsp', 'for the pan', 10),
(@r_ricotta, 'maple syrup', NULL, NULL, 'to serve', 11);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_ricotta,'WHIP & MIX','• Whip egg whites to soft peaks.\n• Whisk dry: flour + baking powder + salt.',1),
(@r_ricotta,'BATTER','• Whisk ricotta + yolks + milk + lemon zest + vanilla.\n• Fold in dry; then fold whites + blueberries gently.',2),
(@r_ricotta,'COOK','• Medium-low heat; butter the pan.\n• 2–3 min/side until golden and just set; serve with maple.',3);



/* ===========================================================
   RECIPE 17: Grilled Chicken Caesar Wrap (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Grilled Chicken Caesar Wrap',
 'grilled-chicken-caesar-wrap',
 'Smoky grilled chicken tossed with crisp romaine, parmesan and a punchy Caesar dressing, all wrapped snugly in a warm tortilla. Crunchy, creamy, portable lunch.',
 'Chicken Caesar salad wrapped in a warm tortilla.',
 'lunch, wrap, chicken, caesar, salad',
 'images/placeholder_caesar_wrap.jpg',
 '12 min','10 min','22 min',
 0,'easy',TRUE,
 'Char the chicken well, then rest before slicing for juicy strips.',
 'Grill or pan-sear chicken; toss romaine with Caesar; add parmesan and crunchy croutons. Roll up in a tortilla; sear seam side down to seal.',
 '• Season chicken with salt, pepper, garlic powder; oil lightly.\n• Shred romaine; grate parmesan; crush small croutons.\n• Whisk quick Caesar: mayo, lemon, Dijon, anchovy/umami, garlic.',
 '• Grill/sear chicken 4–5 min/side; rest; slice.\n• Toss romaine + parmesan + croutons with dressing.\n• Fill tortilla with salad + chicken; wrap; pan-sear to seal.',
 '• Warm tortillas for flexibility.\n• Add a few tomato slices for freshness (optional).',
 '• Don’t overdress—wrap will get soggy.\n• Don’t slice chicken immediately; rest 5 min.',
 'https://www.youtube.com/watch?v=hSYtqP9Rgg8',
 'San Diego, USA', 10, NULL
);

SET @r_caesarwrap = (SELECT recipe_id FROM recipes WHERE slug='grilled-chicken-caesar-wrap' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_caesarwrap, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_caesarwrap;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_caesarwrap, 'chicken breast', '2', 'pc', 'seasoned + grilled', 1),
(@r_caesarwrap, 'romaine lettuce', '3', 'cup', 'shredded', 2),
(@r_caesarwrap, 'parmesan', '1/3', 'cup', 'finely grated', 3),
(@r_caesarwrap, 'croutons', '1/2', 'cup', 'lightly crushed', 4),
(@r_caesarwrap, 'large flour tortillas', '2', 'pc', 'warmed', 5),
(@r_caesarwrap, 'mayonnaise', '3', 'tbsp', 'for Caesar dressing', 6),
(@r_caesarwrap, 'lemon juice', '1', 'tbsp', NULL, 7),
(@r_caesarwrap, 'Dijon mustard', '1', 'tsp', NULL, 8),
(@r_caesarwrap, 'anchovy paste (or umami sauce)', '1/2', 'tsp', 'optional', 9),
(@r_caesarwrap, 'garlic', '1', 'clove', 'grated', 10),
(@r_caesarwrap, 'olive oil', '1', 'tbsp', 'for cooking', 11),
(@r_caesarwrap, 'salt & black pepper', NULL, NULL, 'to taste', 12);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_caesarwrap,'DRESSING & PREP','• Whisk mayo + lemon + Dijon + anchovy + garlic + pepper.\n• Warm tortillas; shred romaine; grate parmesan.',1),
(@r_caesarwrap,'GRILL & SLICE','• Grill chicken 4–5 min/side; rest 5 min; slice strips.',2),
(@r_caesarwrap,'TOSS & WRAP','• Toss romaine + parmesan + croutons with dressing.\n• Fill tortillas with salad + chicken; wrap; pan-sear seam to seal.',3);



/* ===========================================================
   RECIPE 18: Creamy Tomato Basil Gnocchi (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_time, cook_time, total_time,
 views, difficulty, is_featured,
 instructions_intro, instructions, prep_instructions, cook_instructions,
 do_tips, dont_tips, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Tomato Basil Gnocchi',
 'creamy-tomato-basil-gnocchi',
 'Pillowy gnocchi in a silky tomato–cream sauce perfumed with garlic and basil, finished with parmesan. One-pan, weeknight easy, Italian comfort.',
 'One-pan gnocchi with tomato, cream, basil and parmesan.',
 'dinner, gnocchi, tomato cream, basil, vegetarian',
 'images/placeholder_gnocchi_tomato_basil.jpg',
 '8 min','15 min','23 min',
 0,'easy',TRUE,
 'Simmer gnocchi directly in the sauce so it releases starch to thicken.',
 'Bloom garlic and chili in olive oil; add tomato and cream; simmer with gnocchi until tender. Finish with parmesan and basil; loosen with a splash of pasta water if needed.',
 '• Mince garlic; chiffonade basil; grate parmesan.\n• Open tomato passata; measure cream; optional chili flakes ready.',
 '• Sauté garlic + chili in olive oil.\n• Add tomato passata + cream; simmer.\n• Stir in gnocchi; cook 5–7 min until tender and sauce silky.\n• Finish with parmesan + basil; season to taste.',
 '• Reserve a bit of pasta water (or hot water) to adjust consistency.\n• Warm bowls so sauce stays glossy.',
 '• Don’t overcook gnocchi—turns mushy quickly.\n• Don’t let cream boil hard; keep to a gentle simmer.',
 'https://www.youtube.com/watch?v=FhQsmnFSH1E',
 'Turin, Italy', 9, NULL
);

SET @r_gnocchi = (SELECT recipe_id FROM recipes WHERE slug='creamy-tomato-basil-gnocchi' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES
(@r_gnocchi, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_gnocchi;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_gnocchi, 'shelf-stable potato gnocchi', '500', 'g', NULL, 1),
(@r_gnocchi, 'olive oil', '1', 'tbsp', NULL, 2),
(@r_gnocchi, 'garlic', '3', 'clove', 'minced', 3),
(@r_gnocchi, 'red chili flakes', '1/4', 'tsp', 'optional', 4),
(@r_gnocchi, 'tomato passata', '1 1/2', 'cup', NULL, 5),
(@r_gnocchi, 'heavy cream', '1/2', 'cup', NULL, 6),
(@r_gnocchi, 'parmesan', '3/4', 'cup', 'finely grated', 7),
(@r_gnocchi, 'fresh basil', '1/2', 'cup', 'chiffonade + leaves', 8),
(@r_gnocchi, 'pasta water or hot water', '1/4', 'cup', 'as needed', 9),
(@r_gnocchi, 'salt & black pepper', NULL, NULL, 'to taste', 10);

DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi;
INSERT INTO recipe_instruction_sections (recipe_id, section_title, section_body, sort_order) VALUES
(@r_gnocchi,'AROMATICS','• Olive oil; sauté garlic + chili gently until fragrant.',1),
(@r_gnocchi,'SIMMER & COOK','• Add passata + cream; bring to gentle simmer.\n• Stir in gnocchi; cook 5–7 min until tender and sauce silky.',2),
(@r_gnocchi,'FINISH','• Fold in parmesan + basil; season; adjust with a splash of water if thick.',3);
