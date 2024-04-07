ALTER TABLE parts
ALTER COLUMN code SET NOT NULL;

ALTER TABLE parts
ADD UNIQUE(code);

UPDATE parts
SET description = 'None Available'
WHERE description = ' ';

ALTER TABLE parts
ALTER COLUMN description SET NOT NULL;

INSERT INTO parts (id, description, code, manufacturer_id)
VALUES(54, 'None Available', 'V1-009', 9);

ALTER TABLE reorder_options
ADD CHECK ((price_usd Is NOT NULL) AND (quantity Is NOT NULL));

ALTER TABLE reorder_options
ADD CHECK (price_usd > 0 AND quantity > 0);

ALTER TABLE reorder_options
ADD CHECK (price_usd/quantity > 0.02 AND price_usd/quantity < 25.00);

ALTER TABLE parts
ADD PRIMARY KEY (id);

ALTER TABLE reorder_options
ADD FOREIGN KEY (part_id) REFERENCES parts (id);

INSERT INTO reorder_options (id, price_usd, quantity)
VALUES(555, 0.05, 2);

ALTER TABLE locations
ADD cHECK (qty > 0);

ALTER TABLE locations
ADD UNIQUE (part_id, location);

ALTER TABLE locations
ADD FOREIGN KEY (part_id) REFERENCES parts (id);

ALTER TABLE parts
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (id);

INSERT INTO manufacturers (id, name)
VALUES (11, 'Pip-NNC Industrial');

UPDATE parts
SET manufacturer_id = 11
WHERE manufacturer_id IN (1,2);


select *
from parts;
/*
WHERE code = 'V1-009'
order by id
limit 10;
*/
