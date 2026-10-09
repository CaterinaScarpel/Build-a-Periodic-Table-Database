ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;


ALTER TABLE elements ADD UNIQUE(symbol);
ALTER TABLE elements ADD UNIQUE(name);

ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);

CREATE TABLE types(
  type_id SERIAL PRIMARY KEY,
  type VARCHAR NOT NULL
);

INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;


ALTER TABLE properties ADD COLUMN type_id INT;
ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;
ALTER TABLE properties DROP COLUMN type;


/* You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others */
UPDATE elements SET symbol = INITCAP(symbol);

ALTER TABLE properties 
ALTER COLUMN atomic_mass TYPE VARCHAR(9);
UPDATE properties SET atomic_mass = CAST(atomic_mass AS FLOAT);

INSERT INTO elements(atomic_number, symbol, name) VALUES
  (9, 'F', 'Fluorine'),
  (10, 'Ne', 'Neon');

INSERT INTO properties(atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius) VALUES
  (9, 3, 18.998, -220, -188.1),
  (10, 3, 20.18, -248.6, -246.1);
