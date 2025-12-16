# Simply Cooked

A simple recipe sharing website built with native PHP and MySQL. Users can browse, search for recipes, and view cooking details. Admins have a dashboard to manage content.

## Features

* **Home & Browse**: View featured recipes and browse the latest uploads.
* **Recipe Details**: Full view of ingredients, step-by-step instructions, and nutrition info.
* **Search**: Real-time search for recipes by name (AJAX).
* **User Accounts**: Register, Login, and Google Login support.
* **Admin Panel**: Special dashboard for admins to edit recipes and manage users.
* **Responsive Design**: Works on both desktop and mobile devices.

## Requirements

* **XAMPP** (or any PHP/MySQL local server environment).
* PHP 7.4 or higher.
* MySQL.

## How to Install & Run (using XAMPP)

Follow these steps to run the project on your local machine:

### 1. Database Setup
1.  Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
2.  Go to `http://localhost/phpmyadmin`.
3.  Create a new database named: `cooks_delight_db`.
4.  Import the file `script.sql` (located in the `project/` folder) into this database to create the tables.

### 2. Project Setup
1.  Locate your XAMPP installation folder (usually `C:\xampp`).
2.  Open the `htdocs` folder inside it (`C:\xampp\htdocs`).
3.  Copy the entire `project` folder into `htdocs`.
    * *Result should look like:* `C:\xampp\htdocs\project\...`

### 3. Configuration
1.  Open the file `project/config/db.php`.
2.  Check the database connection settings (username, password). By default, XAMPP uses:
    * Host: `localhost`
    * User: `root`
    * Password: (empty)

### 4. Run the Website
1.  Open your web browser.
2.  Access the following URL:
    `http://localhost/project/public/index.php`

*(Note: If you renamed the folder inside htdocs, change the URL accordingly).*

## Folder Structure

* **app/**: Contains the main application logic (Controllers, Models/Functions, Views).
* **config/**: Configuration files for Database and OAuth.
* **public/**: The public-facing folder. Contains `index.php` (entry point), CSS, JS, and uploaded images.
* **project/** (root): Contains SQL scripts for database initialization.

## Notes
* To use Google Login, you must configure your Client ID and Secret in `config/oauth.php`.