create database music_store;
use music_store;

-- 1. Genre and MediaType
CREATE TABLE Genre ( 
genre_id INT PRIMARY KEY, 
name VARCHAR(120) 
);

CREATE TABLE MediaType ( 
media_type_id INT PRIMARY KEY, 
name VARCHAR(120) 
); 

-- 2. Employee 
CREATE TABLE Employee ( 
 employee_id INT PRIMARY KEY, 
 last_name VARCHAR(120), 
 first_name VARCHAR(120), 
 title VARCHAR(120), 
 reports_to INT, 
  levels VARCHAR(255), 
 birthdate DATE, 
 hire_date DATE, 
 address VARCHAR(255), 
 city VARCHAR(100), 
 state VARCHAR(100), 
 country VARCHAR(100), 
 postal_code VARCHAR(20), 
 phone VARCHAR(50), 
 fax VARCHAR(50), 
 email VARCHAR(100) 
);

-- 3. Customer 
CREATE TABLE Customer ( 
 customer_id INT PRIMARY KEY, 
 first_name VARCHAR(120), 
 last_name VARCHAR(120), 
 company VARCHAR(120), 
 address VARCHAR(255), 
 city VARCHAR(100), 
 state VARCHAR(100), 
 country VARCHAR(100), 
 postal_code VARCHAR(20), 
 phone VARCHAR(50), 
 fax VARCHAR(50), 
 email VARCHAR(100), 
 support_rep_id INT, 
 FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id) 
);

-- 4. Artist 
CREATE TABLE Artist ( 
 artist_id INT PRIMARY KEY, 
 name VARCHAR(120) 
);

 -- 5. Album 
CREATE TABLE Album ( 
 album_id INT PRIMARY KEY, 
 title VARCHAR(160), 
 artist_id INT, 
 FOREIGN KEY (artist_id) REFERENCES Artist(artist_id) 
); 

-- 6. Track 
CREATE TABLE Track ( 
track_id INT PRIMARY KEY, 
 name VARCHAR(200), 
 album_id INT, 
 media_type_id INT, 
 genre_id INT, 
 composer VARCHAR(220), 
 milliseconds INT, 
 bytes INT, 
 unit_price DECIMAL(10,2), 
 FOREIGN KEY (album_id) REFERENCES Album(album_id), 
 FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id), 
 FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) 
); 

-- 7. Invoice 
CREATE TABLE Invoice ( 
 invoice_id INT PRIMARY KEY, 
 customer_id INT, 
 invoice_date DATE, 
 billing_address VARCHAR(255), 
 billing_city VARCHAR(100), 
 billing_state VARCHAR(100), 
 billing_country VARCHAR(100), 
 billing_postal_code VARCHAR(20), 
 total DECIMAL(10,2), 
 FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) 
);

-- 8. InvoiceLine 
CREATE TABLE InvoiceLine ( 
 invoice_line_id INT PRIMARY KEY, 
 invoice_id INT, 
 track_id INT, 
 unit_price DECIMAL(10,2), 
 quantity INT, 
 FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id), 
 FOREIGN KEY (track_id) REFERENCES Track(track_id) 
); 

-- 9. Playlist 
CREATE TABLE Playlist ( 
  playlist_id INT PRIMARY KEY, 
 name VARCHAR(255) 
); 

-- 10. PlaylistTrack 
CREATE TABLE PlaylistTrack ( 
 playlist_id INT, 
 track_id INT, 
 PRIMARY KEY (playlist_id, track_id), 
 FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id), 
 FOREIGN KEY (track_id) REFERENCES Track(track_id) 
);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE track
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/playlist_track.csv"
INTO TABLE playlisttrack
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(playlist_id, track_id);


-- Drop foreign keys first to avoid dependency errors
-- Track foreign keys
ALTER TABLE Track DROP FOREIGN KEY track_ibfk_1;
ALTER TABLE Track DROP FOREIGN KEY track_ibfk_2;
ALTER TABLE Track DROP FOREIGN KEY track_ibfk_3;

-- Album foreign key
ALTER TABLE Album DROP FOREIGN KEY album_ibfk_1;

-- Customer foreign key
ALTER TABLE Customer DROP FOREIGN KEY customer_ibfk_1;

-- Invoice foreign key
ALTER TABLE Invoice DROP FOREIGN KEY invoice_ibfk_1;

-- InvoiceLine foreign keys
ALTER TABLE InvoiceLine DROP FOREIGN KEY invoiceline_ibfk_1;
ALTER TABLE InvoiceLine DROP FOREIGN KEY invoiceline_ibfk_2;

-- PlaylistTrack foreign keys
ALTER TABLE PlaylistTrack DROP FOREIGN KEY playlisttrack_ibfk_1;
ALTER TABLE PlaylistTrack DROP FOREIGN KEY playlisttrack_ibfk_2;

-- =========================
-- Add AUTO_INCREMENT to primary keys safely
-- =========================
ALTER TABLE Genre MODIFY genre_id INT AUTO_INCREMENT;
ALTER TABLE MediaType MODIFY media_type_id INT AUTO_INCREMENT;
ALTER TABLE Employee MODIFY employee_id INT AUTO_INCREMENT;
ALTER TABLE Customer MODIFY customer_id INT AUTO_INCREMENT;
ALTER TABLE Artist MODIFY artist_id INT AUTO_INCREMENT;
ALTER TABLE Album MODIFY album_id INT AUTO_INCREMENT;
ALTER TABLE Track MODIFY track_id INT AUTO_INCREMENT;
ALTER TABLE Invoice MODIFY invoice_id INT AUTO_INCREMENT;
ALTER TABLE InvoiceLine MODIFY invoice_line_id INT AUTO_INCREMENT;
ALTER TABLE Playlist MODIFY playlist_id INT AUTO_INCREMENT;
-- PlaylistTrack has composite PK, no AUTO_INCREMENT

-- =========================
-- Recreate foreign keys with ON DELETE CASCADE (or SET NULL)
-- =========================

-- Customer → Employee
ALTER TABLE Customer
ADD CONSTRAINT customer_ibfk_1
FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
ON DELETE SET NULL;

-- Album → Artist
ALTER TABLE Album
ADD CONSTRAINT album_ibfk_1
FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
ON DELETE CASCADE;

-- Track → Album
ALTER TABLE Track
ADD CONSTRAINT track_ibfk_1
FOREIGN KEY (album_id) REFERENCES Album(album_id)
ON DELETE CASCADE;

-- Track → MediaType
ALTER TABLE Track
ADD CONSTRAINT track_ibfk_2
FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id)
ON DELETE CASCADE;

-- Track → Genre
ALTER TABLE Track
ADD CONSTRAINT track_ibfk_3
FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
ON DELETE CASCADE;

-- Invoice → Customer
ALTER TABLE Invoice
ADD CONSTRAINT invoice_ibfk_1
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
ON DELETE CASCADE;

-- InvoiceLine → Invoice
ALTER TABLE InvoiceLine
ADD CONSTRAINT invoice_line_ibfk_1
FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
ON DELETE CASCADE;

-- InvoiceLine → Track
ALTER TABLE InvoiceLine
ADD CONSTRAINT invoice_line_ibfk_2
FOREIGN KEY (track_id) REFERENCES Track(track_id)
ON DELETE CASCADE;

-- PlaylistTrack → Playlist
ALTER TABLE PlaylistTrack
ADD CONSTRAINT playlisttrack_ibfk_1
FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id)
ON DELETE CASCADE;

-- PlaylistTrack → Track
ALTER TABLE PlaylistTrack
ADD CONSTRAINT playlisttrack_ibfk_2
FOREIGN KEY (track_id) REFERENCES Track(track_id)
ON DELETE CASCADE;

-- Task Questions  
-- Senior-most employee based on job title - Nancy	Edwards	Sales Manager	2016-05-01
SELECT first_name, last_name, title, hire_date
FROM Employee
ORDER BY hire_date ASC
LIMIT 1;

-- Countries with the most invoices
-- Count invoices per country
SELECT billing_country, COUNT(*) AS total_invoices
FROM Invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

-- Top 3 values of total invoice
-- Top 3 invoice totals
SELECT DISTINCT total
FROM Invoice
ORDER BY total DESC
LIMIT 3;

-- City with the best customers (highest sum of invoice totals)
-- City with highest total invoice amount
SELECT billing_city, SUM(total) AS total_revenue
FROM Invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

-- Best customer (spent the most money)
-- Customer who spent the most
SELECT c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- Email, name & genre of all Rock music listeners (ordered by email starting with A)
-- Rock music listeners
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
JOIN Track t ON il.track_id = t.track_id
JOIN Genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock' AND c.email LIKE 'A%'
ORDER BY c.email ASC;

-- Artists who wrote the most rock music (top 10)
-- -- Top 10 Rock artists by track count
SELECT ar.name AS artist_name, COUNT(t.track_id) AS rock_track_count
FROM Track t
JOIN Album al ON t.album_id = al.album_id
JOIN Artist ar ON al.artist_id = ar.artist_id
JOIN Genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id
ORDER BY rock_track_count DESC
LIMIT 10;

-- Tracks longer than average song length
SELECT name, milliseconds
FROM Track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM Track)
ORDER BY milliseconds DESC;

-- Amount spent by each customer on each artist
-- Total spent per customer per artist
SELECT c.first_name, c.last_name, ar.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_spent
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
JOIN Track t ON il.track_id = t.track_id
JOIN Album al ON t.album_id = al.album_id
JOIN Artist ar ON al.artist_id = ar.artist_id
GROUP BY c.customer_id, ar.artist_id
ORDER BY total_spent DESC;

-- Most popular genre per country (highest purchases)
-- Most popular genre per country
WITH genre_sales AS (
    SELECT i.billing_country, g.name AS genre, COUNT(*) AS purchases
    FROM Invoice i
    JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
    JOIN Track t ON il.track_id = t.track_id
    JOIN Genre g ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.genre_id
)
SELECT gs.billing_country, gs.genre, gs.purchases
FROM genre_sales gs
JOIN (
    SELECT billing_country, MAX(purchases) AS max_purchases
    FROM genre_sales
    GROUP BY billing_country
) max_gs ON gs.billing_country = max_gs.billing_country AND gs.purchases = max_gs.max_purchases
ORDER BY gs.billing_country;

-- Customer who spent the most per country
-- -- Top spending customer per country
WITH customer_spending AS (
    SELECT i.billing_country, c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(il.unit_price * il.quantity) AS total_spent
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
    GROUP BY i.billing_country, c.customer_id
)
SELECT cs.billing_country, cs.customer_name, cs.total_spent
FROM customer_spending cs
JOIN (
    SELECT billing_country, MAX(total_spent) AS max_spent
    FROM customer_spending
    GROUP BY billing_country
) max_cs ON cs.billing_country = max_cs.billing_country AND cs.total_spent = max_cs.max_spent
ORDER BY cs.billing_country;


