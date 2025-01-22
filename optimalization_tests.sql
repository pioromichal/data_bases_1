DROP INDEX idx_products_product_type;

-- Test wydajności bez indeksów (przed dodaniem dodatkowych indeksów)
-- Zapytanie testowe 1: Wyszukiwanie produktów o określonej nazwie
SET TIMING ON;
SELECT *
FROM Products
WHERE product_type = 'Pale Ale 2';
SET TIMING OFF;

-- Zapytanie testowe 2: Grupowanie produktów według nazwy
SET TIMING ON;
SELECT product_type, COUNT(*)
FROM Products
GROUP BY product_type;
SET TIMING OFF;

-- Dodanie indeksu na kolumnie product_name
CREATE INDEX idx_products_product_type ON Products(product_type);

-- Test wydajności z dodatkowym indeksem

-- Powtórzenie zapytań testowych z indeksem na product_name
-- Zapytanie testowe 1: Wyszukiwanie produktów o określonej nazwie
SET TIMING ON;
SELECT *
FROM Products
WHERE product_type = 'Pale Ale 2';
SET TIMING OFF;

-- Zapytanie testowe 2: Grupowanie produktów według nazwy
SET TIMING ON;
SELECT product_type, COUNT(*)
FROM Products
GROUP BY product_type;
SET TIMING OFF;
