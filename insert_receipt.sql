USE cooks_delight_db;

-- ===================== USERS =====================
INSERT INTO users
(username, email, password_hash, full_name, bio, profile_image_url, role)
VALUES
(
  'isabela_russo',
  'isabela.russo@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Isabela Russo',
  'In the world of pots and pans, I am on a mission to turn everyday meals into memorable moments. I believe cooking is equal parts craft and storytelling, where ingredients become characters and technique creates the plot. At Cooks Delight, I focus on approachable recipes with chef-level results, from quick weeknights to slow-weekend roasts. When I am not testing sauces, I am writing guides that demystify kitchen science so home cooks can shine.',
  '/images/isabela.jpg',
  'admin'  -- Isabela làm admin
),
(
  'marco_lee',
  'marco.lee@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Marco Lee',
  'I am the team’s food stylist and photo wrangler, obsessed with natural light and honest textures. My philosophy is that a good picture should teach you how the food ought to look at every step, not just at the end. I document tests, tiny tweaks, and plating choices so readers can replicate the same finish at home. When the oven is on, my camera is too—capturing the sizzle, the steam, and the story.',
  '/images/marco.jpg',
  'user'
),
(
  'sophia_kim',
  'sophia.kim@cooksdelight.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Sophia Kim',
  'I edit our recipes for clarity and reliability, turning messy notes into step-by-step roadmaps. My background in technical writing meets a lifelong love for baking, so I sweat the details: gram weights, oven behavior, and substitution logic. I maintain our testing logs and quality checks to keep instructions consistent across the site. If a direction feels effortless to follow, that means my job worked.',
  '/images/sophia.jpg',
  'user'
),
(
  'admin',
  'admin@cooksdelight.local',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- = "password"
  'Site Admin',
  'Administrator account for Cooks Delight (dev only).',
  NULL,
  'admin'
);
-- ===================== CATEGORIES =====================
INSERT INTO categories (name, slug) VALUES
('Breakfast','breakfast'),('Lunch','lunch'),('Dinner','dinner')
ON DUPLICATE KEY UPDATE name=VALUES(name);

SET @cat_breakfast = (SELECT category_id FROM categories WHERE slug='breakfast' LIMIT 1);
SET @cat_lunch     = (SELECT category_id FROM categories WHERE slug='lunch' LIMIT 1);
SET @cat_dinner    = (SELECT category_id FROM categories WHERE slug='dinner' LIMIT 1);

-- Tác giả mặc định
SET @author_id = (SELECT user_id FROM users WHERE username='isabela_russo' LIMIT 1);

/* ===========================================================
   RECIPE 1: Lemon Garlic Roasted Chicken (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Lemon Garlic Roasted Chicken',
 'lemon-garlic-roasted-chicken',
 'Picture succulent chicken infused with bright lemon and aromatic garlic. The kitchen warms with citrusy, herbaceous notes as the oven preheats, promising crisp skin and juicy meat. This method focuses on repeatable results for gatherings or relaxed weekends. Steps are broken into clear stages so beginners follow with confidence. Serve with pan juices and roasted lemon for a lively, memorable finish.',
 'Juicy roasted chicken with lemon, garlic and herbs.',
 'chicken, lemon, garlic, roast, dinner',
 'images/recipe_lemon_garlic.png',
 15, 75, 90,
 0,'hard',TRUE,
 'This guide goes beyond basics to help you achieve golden skin and tender meat—every time.',
 'https://www.youtube.com/watch?v=hVf9izhRThY',
 'Tuscany, Italy', 10, "https://www.google.com/maps/embed?origin=mfe&pb=!1m2!2m1!1sTuscany,+Italy"
);

SET @r_chicken = (SELECT recipe_id FROM recipes WHERE slug='lemon-garlic-roasted-chicken' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_chicken, @cat_dinner);

-- Ingredients
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

-- Instructions (sections + steps)
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chicken);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_chicken;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_chicken,'PREHEAT AND PREPARE',1),
(@r_chicken,'CITRUS INFUSION',2),
(@r_chicken,'ROAST TO PERFECTION',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chicken AND section_title='PREHEAT AND PREPARE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chicken AND section_title='CITRUS INFUSION' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chicken AND section_title='ROAST TO PERFECTION' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Preheat oven to 375°F (190°C).', 1),
(@s1, 'Pat the chicken completely dry.', 2),
(@s2, 'Rub minced garlic under the skin.', 1),
(@s2, 'Slide lemon slices evenly under the skin and into the cavity.', 2),
(@s3, 'Roast breast-side up until the thickest part reaches 165°F (74°C).', 1),
(@s3, 'Rest 10 minutes; carve and spoon over pan juices.', 2);

-- Notes (prep/cook/do/dont)
DELETE FROM recipe_notes WHERE recipe_id=@r_chicken;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_chicken,'prep','Preheat oven to 375°F (190°C).',1),
(@r_chicken,'prep','Remove giblets; pat the chicken completely dry.',2),
(@r_chicken,'prep','Gently lift the skin and rub minced garlic directly onto the meat.',3),

(@r_chicken,'cook','Slide lemon slices under the skin and into the cavity.',1),
(@r_chicken,'cook','Whisk olive oil with thyme, rosemary, salt, pepper; brush all over.',2),
(@r_chicken,'cook','Roast breast-side up until internal temperature reaches 165°F (74°C); rest 10 minutes.',3),

(@r_chicken,'do','Wash hands and sanitize surfaces when handling raw poultry.',1),
(@r_chicken,'do','Use separate cutting boards for raw meat and produce.',2),
(@r_chicken,'do','Verify 165°F (74°C) with a probe thermometer.',3),
(@r_chicken,'do','Allow resting time for juicier slices.',4),

(@r_chicken,'dont','Do not thaw chicken at room temperature.',1),
(@r_chicken,'dont','Do not overcrowd the pan—air needs to circulate.',2),
(@r_chicken,'dont','Do not carve immediately after roasting.',3);


/* ===========================================================
   RECIPE 2: Honey Soy Glazed Salmon (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Honey Soy Glazed Salmon',
 'honey-soy-glazed-salmon',
 'A quick skillet method that turns pantry staples into a glossy, savory-sweet glaze. As the sauce reduces, it clings to the salmon and caramelizes at the edges. The result is tender fish with balanced sweetness, salt and garlic warmth. Serve with rice and steamed greens for an effortless weeknight dinner that still feels special.',
 'Salmon fillets with a sticky honey–soy–garlic glaze.',
 'salmon, honey, soy, dinner, quick',
 'images/recipe_honey_soy_salmon.jpg',
 5, 10, 15,
 0,'easy',TRUE,
 'Fast, high-impact flavor with minimal prep.',
 'https://www.youtube.com/watch?v=immZV3_4bmQ',
 'Hokkaido, Japan', 7, "https://www.google.com/maps?q=Hokkaido,+Japan&output=embed"
);

SET @r_salmon = (SELECT recipe_id FROM recipes WHERE slug='honey-soy-glazed-salmon' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_salmon, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_salmon;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_salmon, 'salmon fillet', '2', NULL, 'portions', 1),
(@r_salmon, 'soy sauce', '2', 'tbsp', NULL, 2),
(@r_salmon, 'honey', '1', 'tbsp', NULL, 3),
(@r_salmon, 'garlic', '2', 'clove', 'minced', 4),
(@r_salmon, 'ginger', '1', 'tsp', 'grated', 5),
(@r_salmon, 'sesame oil', '1', 'tsp', NULL, 6);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_salmon;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_salmon,'SEAR THE FISH',1),
(@r_salmon,'MAKE THE GLAZE',2),
(@r_salmon,'FINISH & SERVE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon AND section_title='SEAR THE FISH' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon AND section_title='MAKE THE GLAZE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon AND section_title='FINISH & SERVE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Heat skillet over medium-high heat.', 1),
(@s1, 'Sear salmon 2–3 minutes per side.', 2),
(@s2, 'Add soy sauce, honey, garlic, and ginger.', 1),
(@s2, 'Simmer until syrupy and thick.', 2),
(@s3, 'Spoon glaze over salmon.', 1),
(@s3, 'Rest briefly; serve with rice and greens.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_salmon;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_salmon,'prep','Pat fillets dry; season with a pinch of salt.',1),
(@r_salmon,'prep','Mince garlic; grate fresh ginger.',2),

(@r_salmon,'cook','Sear salmon 2–3 minutes per side.',1),
(@r_salmon,'cook','Add soy + honey + garlic + ginger; reduce to a sticky glaze.',2),
(@r_salmon,'cook','Remove when the center is just opaque.',3),

(@r_salmon,'do','Dry fish for better browning.',1),
(@r_salmon,'do','Tilt the pan and baste to coat evenly.',2),
(@r_salmon,'do','Rest 1–2 minutes before serving.',3),

(@r_salmon,'dont','Do not overcook—remove when just opaque.',1),
(@r_salmon,'dont','Do not crowd the pan; sear in batches if needed.',2);


/* ===========================================================
   RECIPE 3: Creamy Tomato Basil Pasta (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Tomato Basil Pasta',
 'creamy-tomato-basil-pasta',
 'Silky tomato cream sauce that clings to every strand of pasta. Gentle garlic aromatics, a splash of cream and fresh basil create a comforting bowl in under 20 minutes. The method is simple but reliable, perfect for busy lunches or relaxed evenings. Finish with grated parmesan and a little pasta water for a glossy, restaurant-style texture.',
 'Tomato cream pasta with fresh basil.',
 'pasta, tomato, basil, lunch, quick',
 'images/recipe_tomato_basil_pasta.jpg',
 5, 12, 17,
 0,'easy',TRUE,
 'Quick comfort: bright tomato, gentle cream, lots of basil.',
 'https://www.youtube.com/watch?v=k0QfHojj8QM',
 'Campania, Italy', 8, "https://www.google.com/maps?q=Campania,+Italy&output=embed"
);

SET @r_pasta = (SELECT recipe_id FROM recipes WHERE slug='creamy-tomato-basil-pasta' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_pasta, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_pasta;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_pasta, 'pasta', '200', 'g', 'spaghetti or penne', 1),
(@r_pasta, 'garlic', '2', 'clove', 'minced', 2),
(@r_pasta, 'tomato sauce', '1', 'cup', NULL, 3),
(@r_pasta, 'heavy cream', '1/3', 'cup', NULL, 4),
(@r_pasta, 'parmesan', NULL, NULL, 'grated, to taste', 5),
(@r_pasta, 'fresh basil', NULL, NULL, 'torn', 6);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_pasta);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_pasta;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_pasta,'COOK THE PASTA',1),
(@r_pasta,'SIMMER THE SAUCE',2),
(@r_pasta,'TOSS & FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_pasta AND section_title='COOK THE PASTA' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_pasta AND section_title='SIMMER THE SAUCE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_pasta AND section_title='TOSS & FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Boil pasta in well-salted water until al dente.', 1),
(@s1, 'Reserve some pasta water.', 2),
(@s2, 'Sauté garlic briefly without browning.', 1),
(@s2, 'Add tomato sauce and simmer gently 5–7 minutes.', 2),
(@s3, 'Stir in a splash of cream; adjust seasoning.', 1),
(@s3, 'Toss pasta with sauce; loosen with reserved pasta water as needed.', 2),
(@s3, 'Finish with basil and parmesan.', 3);

DELETE FROM recipe_notes WHERE recipe_id=@r_pasta;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_pasta,'prep','Salt pasta water generously.',1),
(@r_pasta,'prep','Mince garlic; chop basil.',2),

(@r_pasta,'cook','Simmer tomato sauce 5–7 minutes.',1),
(@r_pasta,'cook','Add cream; adjust seasoning.',2),
(@r_pasta,'cook','Toss pasta with sauce; use pasta water for gloss.',3),

(@r_pasta,'do','Reserve 1/2 cup pasta water for emulsifying.',1),
(@r_pasta,'do','Warm bowls before serving to keep pasta hot.',2),

(@r_pasta,'dont','Do not overcook pasta—aim for al dente.',1),
(@r_pasta,'dont','Do not brown garlic; keep it fragrant, not bitter.',2);


/* ===========================================================
   RECIPE A: Crispy Scallion Pancakes (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Crispy Scallion Pancakes',
 'crispy-scallion-pancakes',
 'Flaky, layered pancakes studded with heaps of scallions. A simple hot-water dough is folded and rolled to create shattering layers that fry up golden and crisp while staying chewy inside. Dip in soy–vinegar with a touch of chili for a breakfast or snack that disappears fast.',
 'Layered scallion pancakes: flaky, crisp, deeply savory.',
 'breakfast, scallion, pancake, flaky, chinese',
 'images/scallion_pancakes.jpg',
 15, 15, 30,
 0,'medium',TRUE,
 'Hot-water dough and gentle layering create ultra-crisp edges with chewy centers.',
 'https://www.youtube.com/watch?v=JwExHAJQ-II',
 'Shenzhen, China', 10, "https://www.google.com/maps?q=Shenzhen,+China&output=embed"
);

SET @r_scallion = (SELECT recipe_id FROM recipes WHERE slug='crispy-scallion-pancakes' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_scallion, @cat_breakfast);

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

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scallion);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_scallion;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_scallion,'MAKE THE DOUGH',1),
(@r_scallion,'LAYER & SHAPE',2),
(@r_scallion,'ROLL & FRY',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scallion AND section_title='MAKE THE DOUGH' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scallion AND section_title='LAYER & SHAPE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scallion AND section_title='ROLL & FRY' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Combine flour and salt.', 1),
(@s1, 'Stream in hot water while stirring.', 2),
(@s1, 'Knead 2–3 minutes; cover and rest 20 minutes.', 3),
(@s2, 'Roll dough thin and brush with oil.', 1),
(@s2, 'Scatter scallions with a pinch of salt.', 2),
(@s2, 'Roll into a log; coil into a snail; rest 5–10 minutes.', 3),
(@s3, 'Roll to 18–20 cm.', 1),
(@s3, 'Pan-fry in a thin sheen of oil 2–3 minutes per side until deep golden.', 2),
(@s3, 'Slice and serve with soy–vinegar dip.', 3);

DELETE FROM recipe_notes WHERE recipe_id=@r_scallion;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_scallion,'prep','Whisk flour and salt.',1),
(@r_scallion,'prep','Stream in hot water while stirring with chopsticks.',2),
(@r_scallion,'prep','Knead 2–3 minutes until smooth; rest 20 minutes under cover.',3),

(@r_scallion,'cook','Roll dough thin; brush with oil; scatter scallions and a pinch of salt.',1),
(@r_scallion,'cook','Roll up into a log; coil into a snail; rest 5–10 minutes; roll flat (≈18–20 cm).',2),
(@r_scallion,'cook','Pan-fry 2–3 minutes per side over medium until golden and crisp; drain briefly.',3),

(@r_scallion,'do','Use just enough oil to coat the pan.',1),
(@r_scallion,'do','Press gently with a spatula to encourage even browning.',2),
(@r_scallion,'do','Slice like a pizza for easy dipping.',3),

(@r_scallion,'dont','Do not skip the resting—layers will tear and won’t puff.',1),
(@r_scallion,'dont','Do not fry on high heat—outside burns before layers cook.',2);


/* ===========================================================
   RECIPE B: Spicy Lemongrass Beef Rice Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Spicy Lemongrass Beef Rice Bowl',
 'spicy-lemongrass-beef-rice-bowl',
 'Fragrant lemongrass and garlic sear into thin-sliced beef for a fast, high-heat lunch. A quick nuoc cham–style dressing ties everything together over warm rice with crisp veggies and herbs. Spicy, salty, tangy—balanced in every bite.',
 'Vietnamese-style lemongrass beef over rice with nuoc cham.',
 'lunch, beef, lemongrass, vietnamese, rice bowl',
 'images/lemongrass_beef.jpg',
 10, 8, 18,
 0,'easy',TRUE,
 'Prep sauce first; high heat, quick sear.',
 'https://www.youtube.com/watch?v=sjM3QcnqjH4',
 'Ho Chi Minh City, Vietnam', 11, "https://www.google.com/maps?q=Ho+Chi+Minh+City,+Vietnam&output=embed"
);

SET @r_lemongrass = (SELECT recipe_id FROM recipes WHERE slug='spicy-lemongrass-beef-rice-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_lemongrass, @cat_lunch);

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

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_lemongrass,'MIX THE DRESSING',1),
(@r_lemongrass,'MARINATE & PREP',2),
(@r_lemongrass,'SEAR & ASSEMBLE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass AND section_title='MIX THE DRESSING' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass AND section_title='MARINATE & PREP' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_lemongrass AND section_title='SEAR & ASSEMBLE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk fish sauce, sugar, lime juice, and water.', 1),
(@s1, 'Adjust sweet, sour, and salty to taste.', 2),
(@s2, 'Toss beef with lemongrass, garlic, chili and 1 tbsp dressing.', 1),
(@s2, 'Rest 5–10 minutes while slicing vegetables.', 2),
(@s3, 'Sear beef in batches over high heat 60–90 seconds.', 1),
(@s3, 'Deglaze with 1–2 tbsp dressing and toss to coat.', 2),
(@s3, 'Serve over rice with vegetables and herbs; drizzle more dressing.', 3);

DELETE FROM recipe_notes WHERE recipe_id=@r_lemongrass;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_lemongrass,'prep','Slice beef thinly across the grain.',1),
(@r_lemongrass,'prep','Mince lemongrass (white parts), garlic, and chili.',2),
(@r_lemongrass,'prep','Whisk fish sauce, sugar, lime juice, and water for dressing.',3),

(@r_lemongrass,'cook','Sear beef in batches over high heat 60–90 seconds.',1),
(@r_lemongrass,'cook','Deglaze with a spoon of dressing; toss to coat.',2),
(@r_lemongrass,'cook','Assemble bowls with rice, beef, vegetables, and herbs; drizzle dressing.',3),

(@r_lemongrass,'do','Freeze beef 15 minutes for easier slicing.',1),
(@r_lemongrass,'do','Use a very hot pan to avoid steaming.',2),
(@r_lemongrass,'do','Add a knob of butter at the end for gloss (optional).',3),

(@r_lemongrass,'dont','Do not crowd the pan—sear in batches.',1),
(@r_lemongrass,'dont','Do not over-marinate; flavors can turn harsh.',2);


/* ===========================================================
   RECIPE C: Creamy Mushroom Risotto (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Mushroom Risotto',
 'creamy-mushroom-risotto',
 'Classic Northern-Italian risotto, gently stirred to release starches for a luxurious, spoon-coating sauce. Mixed mushrooms bring depth while butter and parmesan finish it glossy and rich. The technique is patient but simple—and the payoff is pure comfort.',
 'Silky arborio rice with mixed mushrooms and parmesan.',
 'dinner, risotto, mushroom, italian, creamy',
 'images/mushroom_risotto.jpg',
 10, 25, 35,
 0,'medium',TRUE,
 'Warm stock, patient stirring, and small additions of liquid are the keys.',
 'https://www.youtube.com/watch?v=8ak3lUxy_yU',
 'Milan, Italy', 9, "https://www.google.com/maps?q=Milan,+Italy&output=embed"
);

SET @r_risotto = (SELECT recipe_id FROM recipes WHERE slug='creamy-mushroom-risotto' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_risotto, @cat_dinner);

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

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_risotto);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_risotto;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_risotto,'PREP & WARM',1),
(@r_risotto,'TOAST & BUILD',2),
(@r_risotto,'STIR TO CREAMINESS',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_risotto AND section_title='PREP & WARM' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_risotto AND section_title='TOAST & BUILD' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_risotto AND section_title='STIR TO CREAMINESS' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Heat stock in a small pot.', 1),
(@s1, 'Dice onion; slice mushrooms; grate cheese.', 2),
(@s2, 'Sweat onion in butter and oil; add mushrooms; season.', 1),
(@s2, 'Stir in rice; toast until edges look translucent.', 2),
(@s2, 'Add wine and reduce to nearly dry.', 3),
(@s3, 'Add hot stock a ladle at a time, stirring often.', 1),
(@s3, 'Cook until rice is al dente and mixture creamy.', 2),
(@s3, 'Finish with butter and parmesan; season to taste.', 3);

DELETE FROM recipe_notes WHERE recipe_id=@r_risotto;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_risotto,'prep','Warm stock in a separate pot.',1),
(@r_risotto,'prep','Dice onion; slice mushrooms; grate parmesan.',2),

(@r_risotto,'cook','Sauté onion in butter and oil; add mushrooms; season.',1),
(@r_risotto,'cook','Stir in rice; toast 1–2 minutes; add wine; reduce.',2),
(@r_risotto,'cook','Add hot stock gradually, stirring until creamy and al dente.',3),

(@r_risotto,'do','Keep stock hot for even absorption.',1),
(@r_risotto,'do','Finish with a cold knob of butter for sheen.',2),
(@r_risotto,'do','Adjust with stock to achieve flowing, creamy texture.',3),

(@r_risotto,'dont','Do not rinse the rice—starch is needed.',1),
(@r_risotto,'dont','Do not dump in too much stock at once.',2);


/* ===========================================================
   RECIPE 4: Shakshuka with Feta (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Shakshuka with Feta',
 'shakshuka-with-feta',
 'Eggs gently poached in a bright, gently spicy tomato–pepper sauce. Crumbles of feta melt into pockets of creaminess while herbs keep it fresh. Scoop with warm bread for a breakfast that feels cozy yet vibrant.',
 'North African tomato–pepper eggs with feta and herbs.',
 'breakfast, shakshuka, eggs, tomato, feta',
 'images/placeholder_shakshuka.jpg',
 10, 18, 28,
 0,'easy',TRUE,
 'Build a flavorful base, then crack in eggs and let them set to your preferred doneness.',
 'https://www.youtube.com/watch?v=GzAwLI2lnm0',
 'Tunis, Tunisia', 9, "https://www.google.com/maps?q=Tunis,+Tunisia&output=embed"
);

SET @r_shak = (SELECT recipe_id FROM recipes WHERE slug='shakshuka-with-feta' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_shak, @cat_breakfast);

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

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_shak);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_shak;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_shak,'AROMATICS & SPICES',1),
(@r_shak,'SIMMER THE SAUCE',2),
(@r_shak,'EGGS & FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_shak AND section_title='AROMATICS & SPICES' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_shak AND section_title='SIMMER THE SAUCE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_shak AND section_title='EGGS & FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Sauté onion and pepper with salt until soft.', 1),
(@s1, 'Add garlic; bloom cumin, paprika, and chili in oil 30–45 seconds.', 2),
(@s2, 'Stir in crushed tomatoes; simmer 8–10 minutes until thick and bright.', 1),
(@s2, 'Adjust salt and pepper.', 2),
(@s3, 'Make 4 wells; crack eggs; cover 5–7 minutes to jammy.', 1),
(@s3, 'Crumble feta; add herbs; serve with warm bread.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_shak;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_shak,'prep','Dice onion and bell pepper; mince garlic.',1),
(@r_shak,'prep','Measure spices: cumin, paprika, chili flakes.',2),
(@r_shak,'prep','Open tomatoes; prepare feta and herbs.',3),

(@r_shak,'cook','Sauté onion and pepper in olive oil; season with salt.',1),
(@r_shak,'cook','Add garlic; bloom cumin, paprika, chili.',2),
(@r_shak,'cook','Add tomatoes; simmer 8–10 minutes until saucy.',3),
(@r_shak,'cook','Make wells; crack eggs; cover 5–7 minutes to jammy; crumble feta; add herbs.',4),

(@r_shak,'do','Warm bread while the eggs set.',1),
(@r_shak,'do','Tilt the pan and spoon sauce over whites for even cooking.',2),

(@r_shak,'dont','Do not overcook the yolks unless you prefer firm.',1),
(@r_shak,'dont','Do not skip blooming spices—the flavor won’t open.',2);

/* ===========================================================
   RECIPE 5: Spicy Pork Bulgogi Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Spicy Pork Bulgogi Bowl',
 'spicy-pork-bulgogi-bowl',
 'Thin-sliced pork shoulder in a gochujang–garlic marinade seared hard for smoky edges. Serve over hot rice with kimchi, cukes and a soft egg. Sweet, spicy, savory—weeknight dynamite.',
 'Korean gochujang pork over rice with crunchy veg.',
 'lunch, korean, bulgogi, pork, gochujang',
 'images/placeholder_pork_bulgogi.jpg',
 15, 8, 23,
 0,'easy',TRUE,
 'Short marination, blazing heat, fast assembly.',
 'https://www.youtube.com/watch?v=Vk4HJ91ctCQ',
 'Seoul, South Korea', 12, "https://www.google.com/maps?q=Seoul,+South+Korea&output=embed"
);

SET @r_bulgogi = (SELECT recipe_id FROM recipes WHERE slug='spicy-pork-bulgogi-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_bulgogi, @cat_lunch);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_bulgogi,'MARINATE',1),
(@r_bulgogi,'SEAR',2),
(@r_bulgogi,'ASSEMBLE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi AND section_title='MARINATE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi AND section_title='SEAR' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_bulgogi AND section_title='ASSEMBLE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk gochujang, soy sauce, sugar, garlic, and sesame oil.', 1),
(@s1, 'Toss pork with marinade and rest 10–15 minutes.', 2),
(@s2, 'Heat a pan very hot and add oil.', 1),
(@s2, 'Sear pork in batches 60–90 seconds until caramelized.', 2),
(@s3, 'Add rice to bowls and top with pork, cucumbers, kimchi, and scallions.', 1),
(@s3, 'Add a soft egg and drizzle sesame oil if desired.', 2);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_bulgogi;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_bulgogi,'prep','Slice pork shoulder thinly; part-freeze 15 minutes for easier cuts.',1),
(@r_bulgogi,'prep','Mince garlic; slice scallions; prepare cucumbers and kimchi.',2),

(@r_bulgogi,'cook','Whisk marinade with gochujang, soy sauce, sugar, garlic, and sesame oil.',1),
(@r_bulgogi,'cook','Toss pork and rest 10–15 minutes.',2),
(@r_bulgogi,'cook','Sear in batches 60–90 seconds until charred at edges.',3),
(@r_bulgogi,'cook','Assemble bowls with rice, pork, cucumbers, kimchi, scallions; add soft egg if desired.',4),

(@r_bulgogi,'do','Use a very hot pan to avoid steaming.',1),
(@r_bulgogi,'do','Add a touch of butter at the end for gloss (optional).',2),

(@r_bulgogi,'dont','Do not crowd the pan; work in batches.',1),
(@r_bulgogi,'dont','Do not marinate too long; acids can toughen meat.',2);



/* ===========================================================
   RECIPE 6: Thai Green Curry with Chicken (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Thai Green Curry with Chicken',
 'thai-green-curry-with-chicken',
 'Fragrant green curry paste blooms in coconut cream for a sauce that’s herbaceous and gently spicy. Tender chicken, Thai eggplant (or zucchini) and kaffir lime leaf deliver a deeply aromatic dinner in under 30 minutes.',
 'Aromatic green curry with coconut, chicken and veg.',
 'dinner, thai, green curry, coconut, chicken',
 'images/placeholder_green_curry.jpg',
 10, 18, 28,
 0, 'medium', TRUE,
 'Bloom curry paste in fat; control thickness with coconut milk and a splash of stock.',
 'https://www.youtube.com/watch?v=yfMn3ZFJHig',
 'Bangkok, Thailand', 11, "https://www.google.com/maps?q=Bangkok,+Thailand&output=embed"
);

SET @r_green = (SELECT recipe_id FROM recipes WHERE slug='thai-green-curry-with-chicken' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_green, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_green;
-- (Giữ nguyên nguyên liệu của bạn nếu có, hoặc thêm sau)

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_green);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_green;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_green,'FRY THE PASTE',1),
(@r_green,'SIMMER',2),
(@r_green,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_green AND section_title='FRY THE PASTE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_green AND section_title='SIMMER' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_green AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Reduce coconut cream until glossy and splitting.', 1),
(@s1, 'Fry green curry paste 1–2 minutes until fragrant.', 2),
(@s2, 'Add chicken and stir to coat.', 1),
(@s2, 'Pour in coconut milk and a little stock; add vegetables.', 2),
(@s2, 'Simmer 8–10 minutes until tender.', 3),
(@s3, 'Season with fish sauce and sugar.', 1),
(@s3, 'Finish with Thai basil and serve with jasmine rice.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_green;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_green,'prep','Slice chicken; prep Thai eggplant or zucchini; tear kaffir lime leaves.',1),
(@r_green,'prep','Separate thick coconut cream from thinner milk if using canned.',2),

(@r_green,'cook','Reduce coconut cream and fry curry paste 1–2 minutes.',1),
(@r_green,'cook','Add chicken and coat with paste; add coconut milk and stock.',2),
(@r_green,'cook','Simmer with vegetables 8–10 minutes; season with fish sauce and sugar.',3),
(@r_green,'cook','Finish with Thai basil and serve with jasmine rice.',4),

(@r_green,'do','Balance salt with fish sauce, sweet with sugar, and heat with curry paste to taste.',1),
(@r_green,'do','If too thick, add stock; if too thin, simmer uncovered to reduce.',2),

(@r_green,'dont','Do not burn the curry paste; keep it sizzling but controlled.',1),
(@r_green,'dont','Do not boil vigorously after adding basil to preserve aroma.',2);



/* ===========================================================
   RECIPE 7: Tamagoyaki Breakfast Sando (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Tamagoyaki Breakfast Sando',
 'tamagoyaki-breakfast-sando',
 'Thick, custardy Japanese rolled omelet tucked between soft milk bread with a swipe of Kewpie mayo and a sprinkle of scallions. Sweet–savory, bouncy, and incredibly satisfying for a fast breakfast.',
 'Fluffy Japanese rolled omelet sandwich on milk bread.',
 'breakfast, tamagoyaki, sandwich, japanese, egg',
 'images/placeholder_tamagoyaki_sando.jpg',
 10, 8, 18,
 0, 'easy', TRUE,
 'Low heat and patient rolling give the signature layers.',
 'https://www.youtube.com/watch?v=43Ii7Rqkd7g',
 'Tokyo, Japan', 12, "https://www.google.com/maps?q=Tokyo,+Japan&output=embed"
);

SET @r_tamago = (SELECT recipe_id FROM recipes WHERE slug='tamagoyaki-breakfast-sando' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_tamago, @cat_breakfast);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tamago);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_tamago;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_tamago,'PREP',1),
(@r_tamago,'COOK THE LAYERS',2),
(@r_tamago,'ASSEMBLE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tamago AND section_title='PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tamago AND section_title='COOK THE LAYERS' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tamago AND section_title='ASSEMBLE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Beat eggs with sugar, mirin, and soy; strain for smooth texture.', 1),
(@s1, 'Prepare milk bread, Kewpie mayo, and scallions.', 2),
(@s1, 'Heat a small rectangular or round pan over low heat.', 3),
(@s2, 'Brush pan with oil and add a thin egg layer.', 1),
(@s2, 'When just set, roll to one side.', 2),
(@s2, 'Oil pan, add more egg, lift the roll so egg flows underneath, and roll again.', 3),
(@s2, 'Repeat until thick and bouncy.', 4),
(@s3, 'Spread mayo on bread, add tamagoyaki, sprinkle scallions, press and cut.', 1);

DELETE FROM recipe_notes WHERE recipe_id=@r_tamago;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_tamago,'prep','Beat eggs with sugar, mirin, and soy; strain for extra smoothness.',1),
(@r_tamago,'prep','Prep milk bread, Kewpie mayo, and scallions.',2),
(@r_tamago,'prep','Preheat the pan over low heat.',3),

(@r_tamago,'cook','Brush pan with oil and work in thin layers, rolling each pass.',1),
(@r_tamago,'cook','Oil before each addition and let egg flow under the roll.',2),
(@r_tamago,'cook','Repeat to build height; keep heat low so layers set without browning.',3),

(@r_tamago,'do','Keep heat low so layers set gently.',1),
(@r_tamago,'do','Strain eggs to remove bubbles.',2),
(@r_tamago,'do','Square the roll gently with chopsticks for clean edges.',3),

(@r_tamago,'dont','Do not rush the roll; raw layers will ooze.',1),
(@r_tamago,'dont','Do not over-brown; bitterness creeps in.',2);



/* ===========================================================
   RECIPE 8: Mediterranean Chickpea & Feta Salad (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Mediterranean Chickpea & Feta Salad',
 'mediterranean-chickpea-and-feta-salad',
 'A no-cook, ultra-crunchy lunch: chickpeas, crisp cucumbers, tomatoes and peppers tossed in a lemon–oregano vinaigrette, finished with briny feta and herbs. Meal-prep friendly and bright for days.',
 'Zesty chickpea salad with feta, lemon and herbs.',
 'lunch, salad, chickpea, feta, mediterranean',
 'images/placeholder_chickpea_feta_salad.jpg',
 12, 0, 12,
 0, 'easy', TRUE,
 'Salt vegetables lightly first so the dressing clings.',
 'https://www.youtube.com/watch?v=NwNvXSNAOFg',
 'Athens, Greece', 10, "https://www.google.com/maps?q=Athens,+Greece&output=embed"
);

SET @r_chickpea = (SELECT recipe_id FROM recipes WHERE slug='mediterranean-chickpea-and-feta-salad' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_chickpea, @cat_lunch);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_chickpea,'MAKE DRESSING',1),
(@r_chickpea,'TOSS',2),
(@r_chickpea,'FINISH & REST',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea AND section_title='MAKE DRESSING' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea AND section_title='TOSS' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_chickpea AND section_title='FINISH & REST' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk lemon juice, olive oil, Dijon, garlic, and oregano.', 1),
(@s2, 'Rinse and drain chickpeas; pat dry.', 1),
(@s2, 'Toss chickpeas and vegetables with dressing; season.', 2),
(@s3, 'Fold in feta and parsley; add olives if desired.', 1),
(@s3, 'Rest 5–10 minutes and serve or box for meal prep.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_chickpea;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_chickpea,'prep','Rinse and drain chickpeas.',1),
(@r_chickpea,'prep','Dice cucumber, tomato, bell pepper; slice red onion.',2),
(@r_chickpea,'prep','Whisk dressing of lemon juice, olive oil, Dijon, garlic, oregano.',3),

(@r_chickpea,'cook','Toss chickpeas and vegetables with dressing; season to taste.',1),
(@r_chickpea,'cook','Fold in feta and parsley; add olives if desired.',2),
(@r_chickpea,'cook','Rest 5–10 minutes before serving.',3),

(@r_chickpea,'do','Pat chickpeas dry for better texture.',1),
(@r_chickpea,'do','Add a pinch of sugar if lemons are very tart.',2),

(@r_chickpea,'dont','Do not crumble feta too fine; leave creamy chunks.',1),
(@r_chickpea,'dont','Do not overdress; it should be shiny, not soupy.',2);



/* ===========================================================
   RECIPE 9: Moroccan Chicken Tagine with Apricots (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Moroccan Chicken Tagine with Apricots',
 'moroccan-chicken-tagine-with-apricots',
 'Braised chicken scented with ras el hanout, ginger and saffron, simmered low with onions until tender and glossy. Sweet dried apricots and toasted almonds finish a sauce that’s spiced, savory and gently sweet—perfect over couscous.',
 'Fragrant Moroccan chicken braise with apricots and almonds.',
 'dinner, moroccan, tagine, chicken, apricot',
 'images/placeholder_moroccan_tagine.jpg',
 15, 45, 60,
 0, 'medium', TRUE,
 'Bloom spices in oil, then braise gently—low and slow.',
 'https://www.youtube.com/watch?v=ZQjqx_JDqb4',
 'Marrakesh, Morocco', 8, "https://www.google.com/maps?q=Marrakesh,+Morocco&output=embed"
);

SET @r_tagine = (SELECT recipe_id FROM recipes WHERE slug='moroccan-chicken-tagine-with-apricots' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_tagine, @cat_dinner);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tagine);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_tagine;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_tagine,'SPICE BASE',1),
(@r_tagine,'BRAISE',2),
(@r_tagine,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tagine AND section_title='SPICE BASE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tagine AND section_title='BRAISE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_tagine AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Mix ras el hanout with ground ginger, turmeric, and cinnamon; bloom saffron in warm stock.', 1),
(@s1, 'Slice onions and chop herbs; ready dried apricots and almonds.', 2),
(@s2, 'Brown chicken lightly in oil and remove.', 1),
(@s2, 'Sweat onions; add garlic and spices until fragrant.', 2),
(@s2, 'Return chicken; add saffron stock; cover and braise 30–35 minutes.', 3),
(@s3, 'Stir in apricots; simmer 5–8 minutes; adjust seasoning.', 1),
(@s3, 'Top with toasted almonds and herbs; serve with couscous.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_tagine;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_tagine,'prep','Mix spice base with ras el hanout, ground ginger, turmeric, cinnamon.',1),
(@r_tagine,'prep','Bloom saffron in warm stock.',2),
(@r_tagine,'prep','Slice onions; chop herbs; prepare dried apricots and almonds.',3),

(@r_tagine,'cook','Brown chicken and remove.',1),
(@r_tagine,'cook','Sweat onions; add garlic and spices until fragrant.',2),
(@r_tagine,'cook','Braise with saffron stock 30–35 minutes.',3),
(@r_tagine,'cook','Finish with apricots; simmer and adjust seasoning; top with almonds and herbs.',4),

(@r_tagine,'do','Use bone-in thighs for maximum flavor.',1),
(@r_tagine,'do','A touch of honey balances acidity if needed.',2),

(@r_tagine,'dont','Do not scorch the spices; keep heat moderate.',1),
(@r_tagine,'dont','Do not skip resting 5 minutes before serving.',2);



/* ===========================================================
   RECIPE 10: Banana-Nut Overnight Oats (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Banana-Nut Overnight Oats',
 'banana-nut-overnight-oats',
 'Creamy, no-cook oats soaked overnight with yogurt and mashed banana. Toasted nuts add crunch while cinnamon and vanilla make it taste like banana bread. Perfect grab-and-go breakfast.',
 'Overnight oats with banana, yogurt and toasted nuts.',
 'breakfast, oats, banana, yogurt, make-ahead',
 'images/placeholder_overnight_oats.jpg',
 8, 0, 8,
 0, 'easy', TRUE,
 'Stir, chill overnight, top and eat—no stove required.',
 'https://www.youtube.com/watch?v=AsQc5xhOmFc',
 'Portland, USA', 9, "https://www.google.com/maps?q=Portland,+USA&output=embed"
);

SET @r_oats = (SELECT recipe_id FROM recipes WHERE slug='banana-nut-overnight-oats' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_oats, @cat_breakfast);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_oats);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_oats;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_oats,'MIX',1),
(@r_oats,'CHILL',2),
(@r_oats,'SERVE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_oats AND section_title='MIX' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_oats AND section_title='CHILL' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_oats AND section_title='SERVE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Stir oats, milk, and yogurt with mashed banana, vanilla, and cinnamon.', 1),
(@s2, 'Divide into jars and chill overnight at least 6–8 hours.', 1),
(@s3, 'Loosen with a splash of milk; top with toasted walnuts, sliced banana, and honey.', 1);

DELETE FROM recipe_notes WHERE recipe_id=@r_oats;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_oats,'prep','Mash a ripe banana.',1),
(@r_oats,'prep','Measure rolled oats, milk, and yogurt.',2),
(@r_oats,'prep','Toast walnuts lightly and let cool.',3),

(@r_oats,'cook','Mix oats, milk, yogurt, mashed banana, vanilla, and cinnamon.',1),
(@r_oats,'cook','Chill overnight 6–8 hours.',2),
(@r_oats,'cook','Serve with walnuts, extra banana, and honey.',3),

(@r_oats,'do','Use ripe bananas for natural sweetness.',1),
(@r_oats,'do','Toast nuts for deeper flavor.',2),
(@r_oats,'do','Make two to three jars at once for the week.',3),

(@r_oats,'dont','Do not use instant oats if you want more texture.',1),
(@r_oats,'dont','Do not skip chilling; hydration is key to creaminess.',2);



/* ===========================================================
   RECIPE 11: Chipotle Chicken Burrito Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Chipotle Chicken Burrito Bowl',
 'chipotle-chicken-burrito-bowl',
 'Smoky chipotle chicken over cilantro-lime rice with sweet corn, black beans and crisp veggies. A cool yogurt-lime sauce ties everything together—fast, colorful lunch that meal-preps like a champ.',
 'Smoky chipotle chicken with cilantro-lime rice and toppings.',
 'lunch, burrito bowl, chicken, chipotle, meal prep',
 'images/placeholder_burrito_bowl.jpg',
 15, 15, 30,
 0, 'easy', TRUE,
 'Marinate briefly, sear hot, and build bowls with contrasting textures.',
 'https://www.youtube.com/watch?v=PtTrjiLpTSc',
 'Austin, USA', 10, "https://www.google.com/maps?q=Austin,+USA&output=embed"
);

SET @r_burrito = (SELECT recipe_id FROM recipes WHERE slug='chipotle-chicken-burrito-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_burrito, @cat_lunch);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_burrito);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_burrito;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_burrito,'RICE & SAUCE',1),
(@r_burrito,'COOK CHICKEN',2),
(@r_burrito,'ASSEMBLE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_burrito AND section_title='RICE & SAUCE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_burrito AND section_title='COOK CHICKEN' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_burrito AND section_title='ASSEMBLE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Cook rice and toss hot rice with lime juice, zest, and chopped cilantro.', 1),
(@s1, 'Whisk chipotle marinade and a separate yogurt-lime sauce.', 2),
(@s2, 'Sear marinated chicken 3–4 minutes per side; rest and slice.', 1),
(@s3, 'Assemble bowls with rice, chicken, black beans, corn, lettuce, pico, and avocado.', 1),
(@s3, 'Spoon yogurt-lime sauce and finish with cilantro.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_burrito;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_burrito,'prep','Cook rice; toss with lime juice, zest, and cilantro.',1),
(@r_burrito,'prep','Whisk marinade of chipotle in adobo, garlic, cumin, lime, and oil.',2),
(@r_burrito,'prep','Stir yogurt-lime sauce separately.',3),

(@r_burrito,'cook','Sear marinated chicken 3–4 minutes per side; rest and slice.',1),
(@r_burrito,'cook','Assemble with rice, chicken, beans, corn, lettuce, pico, avocado; add sauce.',2),

(@r_burrito,'do','Quick-marinate 10–15 minutes still works.',1),
(@r_burrito,'do','Char edges for smoky flavor.',2),
(@r_burrito,'do','Keep extra sauce for tomorrow.',3),

(@r_burrito,'dont','Do not crowd the pan or chicken will steam.',1),
(@r_burrito,'dont','Do not overdress; keep it bright, not heavy.',2);



/* ===========================================================
   RECIPE 12: Butter Chicken (Murgh Makhani) (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Butter Chicken (Murgh Makhani)',
 'butter-chicken-murgh-makhani',
 'Tender yogurt-marinated chicken in a velvety tomato-butter sauce perfumed with garam masala, kasuri methi and ginger. Rich, mildly spiced and perfectly scoopable with naan or rice.',
 'Creamy tomato-butter chicken with warm spices.',
 'dinner, indian, butter chicken, curry',
 'images/placeholder_butter_chicken.jpg',
 20, 25, 45,
 0, 'medium', TRUE,
 'Marinate chicken for tenderness, then simmer in a silky, slightly sweet tomato-butter sauce.',
 'https://www.youtube.com/watch?v=6QrNfWjAPfc',
 'Delhi, India', 10, "https://www.google.com/maps?q=Delhi,+India&output=embed"
);

SET @r_butter = (SELECT recipe_id FROM recipes WHERE slug='butter-chicken-murgh-makhani' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_butter, @cat_dinner);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_butter);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_butter;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_butter,'MARINATE',1),
(@r_butter,'SEAR & SAUCE',2),
(@r_butter,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_butter AND section_title='MARINATE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_butter AND section_title='SEAR & SAUCE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_butter AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk yogurt, ginger–garlic paste, garam masala, chili, turmeric, and salt.', 1),
(@s1, 'Toss chicken and rest 20–30 minutes or longer if time allows.', 2),
(@s2, 'Sear chicken in a thin film of oil until lightly charred; remove.', 1),
(@s2, 'Sauté onion; add ginger–garlic and spices; add tomato purée and simmer.', 2),
(@s3, 'Return chicken; add butter and cream; crush kasuri methi; simmer to coat.', 1);

DELETE FROM recipe_notes WHERE recipe_id=@r_butter;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_butter,'prep','Whisk marinade with yogurt, ginger–garlic paste, garam masala, chili, turmeric, and salt.',1),
(@r_butter,'prep','Marinate chicken 20–30 minutes or longer.',2),
(@r_butter,'prep','Prepare sauce aromatics: onion, tomato purée, butter, cream.',3),

(@r_butter,'cook','Sear marinated chicken; set aside.',1),
(@r_butter,'cook','Sauté onion; add ginger–garlic and spices; add tomato purée; simmer.',2),
(@r_butter,'cook','Return chicken; finish with butter and cream; crush kasuri methi.',3),

(@r_butter,'do','Blend the sauce smooth for restaurant-style texture.',1),
(@r_butter,'do','Finish with a knob of cold butter for sheen.',2),
(@r_butter,'do','Add a pinch of sugar to balance acidity if needed.',3),

(@r_butter,'dont','Do not burn the spices; keep them fragrant, not dark.',1),
(@r_butter,'dont','Do not overreduce; sauce should be pourable and creamy.',2);



/* ===========================================================
   RECIPE 13: Savory Miso Oat Congee (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Savory Miso Oat Congee',
 'savory-miso-oat-congee',
 'Comforting, savory “congee” made from rolled oats simmered with ginger and scallions, then finished with white miso for deep umami. A soft egg, sesame oil, and crunchy toppings turn it into a complete, cozy breakfast.',
 'Cozy miso-ginger oat congee with egg and scallions.',
 'breakfast, oats, miso, congee, savory',
 'images/placeholder_miso_oat_congee.jpg',
 5, 12, 17,
 0, 'easy', TRUE,
 'Rinse oats briefly to remove chalkiness; miso goes in off the heat to keep it fragrant.',
 'https://www.youtube.com/watch?v=_b6WFymVeq0',
 'Sapporo, Japan', 9, "https://www.google.com/maps?q=Sapporo,+Japan&output=embed"
);

SET @r_congee = (SELECT recipe_id FROM recipes WHERE slug='savory-miso-oat-congee' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_congee, @cat_breakfast);

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_congee);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_congee;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_congee,'PREP',1),
(@r_congee,'SIMMER',2),
(@r_congee,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_congee AND section_title='PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_congee AND section_title='SIMMER' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_congee AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Rinse rolled oats quickly and drain well.', 1),
(@s1, 'Slice scallions, separating whites and greens; grate ginger.', 2),
(@s2, 'Simmer oats with water, ginger, and scallion whites 10–12 minutes, stirring.', 1),
(@s3, 'Off heat, whisk in white miso until smooth.', 1),
(@s3, 'Bowl up; top with a soft egg, scallion greens, sesame oil, chili crisp, and seeds.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_congee;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_congee,'prep','Rinse rolled oats quickly and drain well.',1),
(@r_congee,'prep','Slice scallions (whites and greens separated) and grate ginger.',2),
(@r_congee,'prep','Prepare toppings: soft egg, sesame oil, chili crisp, toasted seeds.',3),

(@r_congee,'cook','Simmer oats with water, ginger, and scallion whites 10–12 minutes.',1),
(@r_congee,'cook','Whisk in miso off heat until smooth.',2),
(@r_congee,'cook','Serve with toppings to taste.',3),

(@r_congee,'do','Add a splash of stock for extra savoriness.',1),
(@r_congee,'do','Stir often for creaminess without sticking.',2),

(@r_congee,'dont','Do not boil miso; add off heat to preserve aroma.',1),
(@r_congee,'dont','Do not skip the salt check; miso salinity varies.',2);



/* ===========================================================
   RECIPE 14: Grilled Halloumi Pita with Tzatziki (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Grilled Halloumi Pita with Tzatziki',
 'grilled-halloumi-pita-with-tzatziki',
 'Squeaky, golden-seared halloumi tucked into warm pita with juicy tomatoes, cucumbers, herbs and a cool garlicky tzatziki. Bright, filling, and meatless—perfect lunch in minutes.',
 'Halloumi pita with fresh veg and creamy tzatziki.',
 'lunch, vegetarian, halloumi, pita, tzatziki',
 'images/placeholder_halloumi_pita.jpg',
 12, 8, 20,
 0,'easy',TRUE,
 'Pat halloumi dry before searing so it browns, not steams.',
 'https://www.youtube.com/watch?v=K96wtA01J0k',
 'Thessaloniki, Greece', 10, "https://www.google.com/maps?q=Thessaloniki,+Greece&output=embed"
);

SET @r_halloumi = (SELECT recipe_id FROM recipes WHERE slug='grilled-halloumi-pita-with-tzatziki' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_halloumi, @cat_lunch);

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

DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_halloumi,'TZATZIKI',1),
(@r_halloumi,'SEAR & WARM',2),
(@r_halloumi,'ASSEMBLE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi AND section_title='TZATZIKI' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi AND section_title='SEAR & WARM' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_halloumi AND section_title='ASSEMBLE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Mix yogurt, grated cucumber, garlic, lemon juice, olive oil, and salt; chill.', 1),
(@s2, 'Sear halloumi 2–3 minutes per side until deeply golden; warm pitas briefly.', 1),
(@s3, 'Spread tzatziki; add halloumi, tomatoes, cucumber, onion, and herbs.', 1),
(@s3, 'Sprinkle sumac and squeeze lemon before serving.', 2);

DELETE FROM recipe_notes WHERE recipe_id=@r_halloumi;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_halloumi,'prep','Pat halloumi dry and slice 1 cm.',1),
(@r_halloumi,'prep','Dice tomatoes and cucumber; slice red onion; chop dill and mint.',2),
(@r_halloumi,'prep','Mix tzatziki from yogurt, grated cucumber, garlic, lemon, olive oil, and salt.',3),

(@r_halloumi,'cook','Sear halloumi 2–3 minutes per side until golden.',1),
(@r_halloumi,'cook','Warm pitas; assemble with sauce and vegetables.',2),

(@r_halloumi,'do','Salt tomatoes lightly so juices concentrate.',1),
(@r_halloumi,'do','Add a pinch of sumac for citrusy pop.',2),

(@r_halloumi,'dont','Do not overcrowd the pan; halloumi needs contact to brown.',1),
(@r_halloumi,'dont','Do not skip pat-drying; moisture prevents crust.',2);


/* ===========================================================
   RECIPE 15: Garlicky Shrimp Scampi Linguine (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Garlicky Shrimp Scampi Linguine',
 'garlicky-shrimp-scampi-linguine',
 'Buttery, lemony shrimp scampi tossed with al dente linguine, loads of garlic and a splash of white wine. Bright, fast, and restaurant-level weeknight dinner.',
 'Linguine with lemon–garlic shrimp and white wine butter sauce.',
 'dinner, pasta, shrimp scampi, lemon, quick',
 'images/placeholder_shrimp_scampi.jpg',
 10, 12, 22,
 0,'easy',TRUE,
 'Pull pasta just shy of al dente and finish in the pan so it drinks up the sauce.',
 'https://www.youtube.com/watch?v=FmrvfaoOX8A',
 'Naples, Italy', 9, "https://www.google.com/maps?q=Naples,+Italy&output=embed"
);

SET @r_scampi = (SELECT recipe_id FROM recipes WHERE slug='garlicky-shrimp-scampi-linguine' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_scampi, @cat_dinner);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scampi);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_scampi;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_scampi,'PASTA & PREP',1),
(@r_scampi,'SAUCE BASE',2),
(@r_scampi,'EMULSIFY & TOSS',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scampi AND section_title='PASTA & PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scampi AND section_title='SAUCE BASE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_scampi AND section_title='EMULSIFY & TOSS' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Thaw and pat dry shrimp; season lightly with salt.', 1),
(@s1, 'Boil linguine in salted water and reserve 1 cup pasta water.', 2),
(@s1, 'Mince garlic, chop parsley, and cut lemon.', 3),
(@s2, 'Sauté garlic in butter and olive oil and add chili flakes.', 1),
(@s2, 'Add shrimp and cook just until pink; remove.', 2),
(@s3, 'Deglaze with white wine and lemon juice and reduce slightly.', 1),
(@s3, 'Toss in pasta with a splash of pasta water to emulsify; return shrimp.', 2),
(@s3, 'Finish with butter and parsley and season to taste.', 3);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_scampi;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_scampi,'prep','Pat shrimp dry and season lightly with salt.',1),
(@r_scampi,'prep','Boil linguine in salted water and reserve pasta water.',2),
(@r_scampi,'prep','Mince garlic, chop parsley, zest half the lemon if desired.',3),

(@r_scampi,'cook','Sauté garlic gently in butter and olive oil; add chili flakes.',1),
(@r_scampi,'cook','Sear shrimp briefly and remove before overcooking.',2),
(@r_scampi,'cook','Deglaze with white wine and lemon; reduce and emulsify with pasta water.',3),
(@r_scampi,'cook','Return shrimp, finish with butter and parsley, and season.',4),

(@r_scampi,'do','Emulsify with starchy pasta water for a silky sauce.',1),
(@r_scampi,'do','Use lemon zest for extra fragrance.',2),

(@r_scampi,'dont','Do not overcook shrimp; they turn rubbery quickly.',1),
(@r_scampi,'dont','Do not add too much cheese; a light sprinkle is enough.',2);



/* ===========================================================
   SEAFOOD 1: Smoked Salmon Avocado Toast w/ Poached Egg (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Smoked Salmon Avocado Toast with Poached Egg',
 'smoked-salmon-avocado-toast-poached-egg',
 'Creamy avocado smashed on crisp toast, topped with silky smoked salmon and a jammy poached egg. Briny capers, lemon, and dill keep it bright—protein-packed breakfast in minutes.',
 'Avocado toast with smoked salmon, poached egg, capers and dill.',
 'breakfast, smoked salmon, avocado toast, poached egg',
 'images/placeholder_salmon_avotoast.jpg',
 8, 6, 14,
 0,'easy',TRUE,
 'Toast, smash, and poach to build layers of texture and brightness.',
 'https://www.youtube.com/watch?v=jqzF2AgQmoI',
 'Copenhagen, Denmark', 10, "https://www.google.com/maps?q=Copenhagen,+Denmark&output=embed"
);

SET @r_salmon_toast = (SELECT recipe_id FROM recipes WHERE slug='smoked-salmon-avocado-toast-poached-egg' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_salmon_toast, @cat_breakfast);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_salmon_toast,'PREP',1),
(@r_salmon_toast,'POACH & BUILD',2),
(@r_salmon_toast,'SERVE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast AND section_title='PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast AND section_title='POACH & BUILD' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_salmon_toast AND section_title='SERVE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Bring a small pot of water to a bare simmer and add a splash of vinegar.', 1),
(@s1, 'Toast sourdough and slice avocado and lemon; pick dill and drain capers.', 2),
(@s2, 'Smash avocado with lemon juice and salt.', 1),
(@s2, 'Swirl water, crack egg into the center, and poach about 3 minutes.', 2),
(@s2, 'Spread avocado on toast and layer smoked salmon, capers, and dill.', 3),
(@s2, 'Top with egg and finish with black pepper and chili flakes if desired.', 4),
(@s3, 'Serve on warm plates with extra lemon if desired.', 1);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_salmon_toast;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_salmon_toast,'prep','Dry capers on a paper towel for extra pop.',1),
(@r_salmon_toast,'prep','Warm plates so toast stays crisp.',2),

(@r_salmon_toast,'cook','Maintain a gentle simmer when poaching eggs.',1),

(@r_salmon_toast,'do','Use warm toast and cold salmon for contrast.',1),

(@r_salmon_toast,'dont','Do not boil vigorously while poaching; whites will fray.',1),
(@r_salmon_toast,'dont','Do not oversalt; salmon and capers are already salty.',2);



/* ===========================================================
   SEAFOOD 2: Ahi Tuna Poke Bowl (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Ahi Tuna Poke Bowl',
 'ahi-tuna-poke-bowl',
 'Sushi-grade ahi tuna dressed in a soy–sesame marinade over warm rice with avocado, cucumber, edamame and scallions. Clean, fresh, and incredibly satisfying for lunch.',
 'Hawaiian-style tuna poke over rice with crisp veggies.',
 'lunch, poke, tuna, hawaiian, rice bowl',
 'images/placeholder_tuna_poke.jpg',
 12, 0, 12,
 0,'easy',TRUE,
 'Use very fresh, sushi-grade tuna and keep ingredients cold.',
 'https://www.youtube.com/watch?v=4aIWDRtZtRM',
 'Honolulu, Hawaii', 12, "https://www.google.com/maps?q=Honolulu,+Hawaii&output=embed"
);

SET @r_poke = (SELECT recipe_id FROM recipes WHERE slug='ahi-tuna-poke-bowl' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_poke, @cat_lunch);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_poke);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_poke;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_poke,'MARINADE',1),
(@r_poke,'TOSS & BUILD',2),
(@r_poke,'SERVE',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_poke AND section_title='MARINADE' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_poke AND section_title='TOSS & BUILD' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_poke AND section_title='SERVE' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk soy sauce, toasted sesame oil, rice vinegar, honey, and chili.', 1),
(@s1, 'Chill the marinade briefly.', 2),
(@s2, 'Toss tuna with marinade and sesame seeds for 2–5 minutes.', 1),
(@s2, 'Assemble bowls with warm rice, tuna, cucumber, avocado, and edamame.', 2),
(@s2, 'Finish with furikake and scallions.', 3),
(@s3, 'Serve immediately for best texture.', 1);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_poke;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_poke,'prep','Chill a mixing bowl and cube sushi-grade tuna.',1),
(@r_poke,'prep','Slice cucumber and avocado, thaw edamame, and slice scallions.',2),

(@r_poke,'cook','Toss tuna briefly with marinade and sesame seeds.',1),

(@r_poke,'do','Pat tuna dry for clean cuts.',1),
(@r_poke,'do','Keep rice warm and toppings cold for contrast.',2),

(@r_poke,'dont','Do not overmarinate; acids change texture quickly.',1),
(@r_poke,'dont','Do not use non–sushi-grade fish.',2);



/* ===========================================================
   SEAFOOD 3: Lemon-Caper Butter Baked Cod (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Lemon-Caper Butter Baked Cod',
 'lemon-caper-butter-baked-cod',
 'Flaky white cod baked in a bright lemon–capers–butter pan sauce with garlic and parsley. Simple technique, restaurant-level results—serve with roasted potatoes or greens.',
 'Oven-baked cod with lemon, capers, garlic butter.',
 'dinner, cod, baked fish, lemon caper',
 'images/placeholder_baked_cod.jpg',
 8, 14, 22,
 0,'easy',TRUE,
 'High heat and a quick bake keep cod moist; the sauce builds in the pan.',
 'https://www.youtube.com/watch?v=NoMBecQZhto',
 'Lisbon, Portugal', 9, "https://www.google.com/maps?q=Lisbon,+Portugal&output=embed"
);

SET @r_cod = (SELECT recipe_id FROM recipes WHERE slug='lemon-caper-butter-baked-cod' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_cod, @cat_dinner);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_cod);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_cod;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_cod,'PREHEAT & PREP',1),
(@r_cod,'BAKE',2),
(@r_cod,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_cod AND section_title='PREHEAT & PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_cod AND section_title='BAKE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_cod AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Preheat oven to 220°C (425°F).', 1),
(@s1, 'Pat cod dry; slice lemon; mince garlic; chop parsley.', 2),
(@s2, 'Place cod in a small baking dish and season with salt and pepper.', 1),
(@s2, 'Scatter garlic and capers over cod; dot with butter and add lemon slices.', 2),
(@s2, 'Bake 12–14 minutes until cod flakes easily; baste with pan juices.', 3),
(@s3, 'Squeeze fresh lemon and sprinkle parsley before serving.', 1);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_cod;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_cod,'prep','Use a tight-fitting baking dish so butter does not burn.',1),

(@r_cod,'cook','Pull fish at 50–52°C internal temperature for perfect flake if using a thermometer.',1),

(@r_cod,'dont','Do not overbake; cod dries quickly.',1),
(@r_cod,'dont','Do not skip pat-drying; moisture prevents browning at the edges.',2);



/* ===========================================================
   RECIPE 16: Blueberry Lemon Ricotta Pancakes (Breakfast)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Blueberry Lemon Ricotta Pancakes',
 'blueberry-lemon-ricotta-pancakes',
 'Extra-fluffy pancakes thanks to ricotta and whipped egg whites, studded with juicy blueberries and bright lemon zest. Golden outside, custardy inside—weekend café vibes at home.',
 'Fluffy ricotta pancakes with blueberries and lemon zest.',
 'breakfast, pancakes, ricotta, blueberry, lemon',
 'images/placeholder_ricotta_pancakes.jpg',
 12, 12, 24,
 0,'easy',TRUE,
 'Separate eggs and fold whipped whites in last for cloud-like texture.',
 'https://www.youtube.com/watch?v=iSUIRCa1nwk',
 'Melbourne, Australia', 10, "https://www.google.com/maps?q=Melbourne,+Australia&output=embed"
);

SET @r_ricotta = (SELECT recipe_id FROM recipes WHERE slug='blueberry-lemon-ricotta-pancakes' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_ricotta, @cat_breakfast);

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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_ricotta,'WHIP & MIX',1),
(@r_ricotta,'BATTER',2),
(@r_ricotta,'COOK',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta AND section_title='WHIP & MIX' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta AND section_title='BATTER' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_ricotta AND section_title='COOK' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whip egg whites to soft peaks.', 1),
(@s1, 'Whisk together flour, baking powder, and salt.', 2),
(@s2, 'Whisk ricotta, yolks, milk, lemon zest, and vanilla.', 1),
(@s2, 'Fold in dry ingredients, then gently fold whipped whites and blueberries.', 2),
(@s3, 'Cook pancakes over medium-low with a thin film of butter for 2–3 minutes per side until golden and set; serve with maple syrup.', 1);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_ricotta;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_ricotta,'prep','Zest lemon and pat blueberries dry.',1),

(@r_ricotta,'cook','Wipe the pan between batches and add a thin film of butter.',1),
(@r_ricotta,'cook','Loosen batter with a splash of milk if it thickens.',2),

(@r_ricotta,'do','Keep heat moderate to cook through without burning.',1),

(@r_ricotta,'dont','Do not overmix after adding whipped whites; preserve air.',1),
(@r_ricotta,'dont','Do not cook too hot; the outside burns before the center sets.',2);



/* ===========================================================
   RECIPE 17: Grilled Chicken Caesar Wrap (Lunch)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Grilled Chicken Caesar Wrap',
 'grilled-chicken-caesar-wrap',
 'Smoky grilled chicken tossed with crisp romaine, parmesan and a punchy Caesar dressing, all wrapped snugly in a warm tortilla. Crunchy, creamy, portable lunch.',
 'Chicken Caesar salad wrapped in a warm tortilla.',
 'lunch, wrap, chicken, caesar, salad',
 'images/placeholder_caesar_wrap.jpg',
 12, 10, 22,
 0,'easy',TRUE,
 'Char the chicken well and rest before slicing for juicy strips.',
 'https://www.youtube.com/watch?v=hSYtqP9Rgg8',
 'San Diego, USA', 10, "https://www.google.com/maps?q=San+Diego,+USA&output=embed"
);

SET @r_caesarwrap = (SELECT recipe_id FROM recipes WHERE slug='grilled-chicken-caesar-wrap' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_caesarwrap, @cat_lunch);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_caesarwrap;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_caesarwrap, 'chicken breast', '2', 'pc', 'seasoned and grilled', 1),
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

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_caesarwrap,'DRESSING & PREP',1),
(@r_caesarwrap,'GRILL & SLICE',2),
(@r_caesarwrap,'TOSS & WRAP',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap AND section_title='DRESSING & PREP' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap AND section_title='GRILL & SLICE' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_caesarwrap AND section_title='TOSS & WRAP' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Whisk mayonnaise, lemon juice, Dijon, anchovy paste, garlic, and pepper.', 1),
(@s1, 'Warm tortillas, shred romaine, and grate parmesan.', 2),
(@s2, 'Grill or pan-sear chicken 4–5 minutes per side, rest 5 minutes, and slice into strips.', 1),
(@s3, 'Toss romaine, parmesan, and croutons with Caesar dressing.', 1),
(@s3, 'Fill tortillas with salad and chicken, wrap tightly, and pan-sear seam side down to seal.', 2);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_caesarwrap;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_caesarwrap,'prep','Warm tortillas for flexibility.',1),

(@r_caesarwrap,'do','Add a few tomato slices for freshness if desired.',1),

(@r_caesarwrap,'dont','Do not overdress; the wrap will get soggy.',1),
(@r_caesarwrap,'dont','Do not slice chicken immediately; rest to keep juices.',2);



/* ===========================================================
   RECIPE 18: Creamy Tomato Basil Gnocchi (Dinner)
   =========================================================== */
INSERT INTO recipes
(user_id, title, slug, description, meta_description, keywords,
 main_image_url, prep_minutes, cook_minutes, total_minutes,
 views, difficulty, is_featured,
 instructions_intro, video_url,
 origin_place, origin_zoom, origin_map_embed_url)
VALUES
(@author_id,
 'Creamy Tomato Basil Gnocchi',
 'creamy-tomato-basil-gnocchi',
 'Pillowy gnocchi in a silky tomato–cream sauce perfumed with garlic and basil, finished with parmesan. One-pan, weeknight easy, Italian comfort.',
 'One-pan gnocchi with tomato, cream, basil and parmesan.',
 'dinner, gnocchi, tomato cream, basil, vegetarian',
 'images/placeholder_gnocchi_tomato_basil.jpg',
 8, 15, 23,
 0,'easy',TRUE,
 'Simmer gnocchi directly in the sauce so it releases starch to thicken.',
 'https://www.youtube.com/watch?v=FhQsmnFSH1E',
 'Turin, Italy', 9, "https://www.google.com/maps?q=Turin,+Italy&output=embed"
);

SET @r_gnocchi = (SELECT recipe_id FROM recipes WHERE slug='creamy-tomato-basil-gnocchi' LIMIT 1);
INSERT IGNORE INTO recipe_categories (recipe_id, category_id) VALUES (@r_gnocchi, @cat_dinner);

DELETE FROM recipe_ingredients WHERE recipe_id=@r_gnocchi;
INSERT INTO recipe_ingredients (recipe_id, name, quantity, unit, note, sort_order) VALUES
(@r_gnocchi, 'shelf-stable potato gnocchi', '500', 'g', NULL, 1),
(@r_gnocchi, 'olive oil', '1', 'tbsp', NULL, 2),
(@r_gnocchi, 'garlic', '3', 'clove', 'minced', 3),
(@r_gnocchi, 'red chili flakes', '1/4', 'tsp', 'optional', 4),
(@r_gnocchi, 'tomato passata', '1 1/2', 'cup', NULL, 5),
(@r_gnocchi, 'heavy cream', '1/2', 'cup', NULL, 6),
(@r_gnocchi, 'parmesan', '3/4', 'cup', 'finely grated', 7),
(@r_gnocchi, 'fresh basil', '1/2', 'cup', 'chiffonade and leaves', 8),
(@r_gnocchi, 'pasta water or hot water', '1/4', 'cup', 'as needed', 9),
(@r_gnocchi, 'salt & black pepper', NULL, NULL, 'to taste', 10);

-- Sections + steps
DELETE FROM recipe_instruction_steps 
WHERE section_id IN (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi);
DELETE FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi;

INSERT INTO recipe_instruction_sections (recipe_id, section_title, sort_order) VALUES
(@r_gnocchi,'AROMATICS',1),
(@r_gnocchi,'SIMMER & COOK',2),
(@r_gnocchi,'FINISH',3);

SET @s1 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi AND section_title='AROMATICS' LIMIT 1);
SET @s2 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi AND section_title='SIMMER & COOK' LIMIT 1);
SET @s3 = (SELECT id FROM recipe_instruction_sections WHERE recipe_id=@r_gnocchi AND section_title='FINISH' LIMIT 1);

INSERT INTO recipe_instruction_steps (section_id, step_text, sort_order) VALUES
(@s1, 'Warm olive oil and sauté garlic and chili gently until fragrant.', 1),
(@s2, 'Add tomato passata and cream and bring to a gentle simmer.', 1),
(@s2, 'Stir in gnocchi and cook 5–7 minutes until tender and the sauce is silky.', 2),
(@s3, 'Fold in parmesan and basil, season to taste, and adjust with a splash of water if thick.', 1);

-- Notes
DELETE FROM recipe_notes WHERE recipe_id=@r_gnocchi;
INSERT INTO recipe_notes (recipe_id, content_type, note_text, sort_order) VALUES
(@r_gnocchi,'prep','Mince garlic and chiffonade basil; grate parmesan.',1),

(@r_gnocchi,'cook','Keep cream at a gentle simmer to avoid splitting.',1),

(@r_gnocchi,'do','Reserve a little hot water to adjust sauce consistency.',1),

(@r_gnocchi,'dont','Do not overcook gnocchi; they become mushy quickly.',1),
(@r_gnocchi,'dont','Do not boil the sauce hard; keep it gentle.',2);
