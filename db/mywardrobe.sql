--
-- Create database for Clothes and Outfits
--
PRAGMA foreign_keys = ON;
CREATE TABLE clothesitem (
        id         INTEGER PRIMARY KEY,
        name       TEXT,
        category   TEXT
);
-- 'clothes-outfit' is a many-to-many join table between clothes & outfits
CREATE TABLE clothesoutfit (
        clothes_id     INTEGER REFERENCES clothesitem(id) ON DELETE CASCADE ON UPDATE CASCADE,
        outfit_id   INTEGER REFERENCES outfit(id) ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (clothes_id, outfit_id)
);
CREATE TABLE outfit (
        id          INTEGER PRIMARY KEY,
        tag_name  TEXT
);
---
--- Load some sample data
---
INSERT INTO clothesitem VALUES (1, 'Animal T-Shirt', 'T-SHIRT');
INSERT INTO clothesitem VALUES (2, 'White Stuff Skirt', 'SKIRT');
INSERT INTO clothesitem VALUES (3, 'Diesel Jeans', 'TROUSERS');
INSERT INTO clothesitem VALUES (4, 'Adidas Superstars', 'SHOES');
INSERT INTO clothesitem VALUES (5, 'Black Top', 'TOPS');
INSERT INTO outfit VALUES (1, 'Outfit No1');
INSERT INTO outfit VALUES (2, 'Outfit No2');
INSERT INTO outfit VALUES (3, 'Outfit No3');
INSERT INTO outfit VALUES (4, 'Outfit No4');
INSERT INTO outfit VALUES (5, 'Outfit No5');
INSERT INTO outfit VALUES (6, 'Outfit No6');
INSERT INTO outfit VALUES (7, 'Outfit No7');
INSERT INTO outfit VALUES (8, 'Outfit No8');
INSERT INTO clothesoutfit VALUES (1, 1);
INSERT INTO clothesoutfit VALUES (1, 2);
INSERT INTO clothesoutfit VALUES (1, 3);
INSERT INTO clothesoutfit VALUES (1, 4);
