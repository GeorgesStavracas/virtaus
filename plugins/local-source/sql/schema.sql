CREATE TABLE 'Collection'
(
  id        INTEGER PRIMARY KEY,
  name      TEXT NOT NULL,
  directory TEXT NOT NULL
);

CREATE TABLE 'CollectionInfo'
(
  collection INTEGER NOT NULL,
  field      TEXT NOT NULL,
  value      TEXT NOT NULL,
  PRIMARY KEY (collection, field)
);

CREATE TABLE 'Set'
(
  id            INTEGER PRIMARY KEY,
  name          TEXT NOT NULL,
  collection    INTEGER NOT NULL,
  FOREIGN KEY (collection) REFERENCES Collection(id)
);


CREATE TABLE 'Category'
(
  id          INTEGER PRIMARY KEY,
  collection  INTEGER NOT NULL,
  name        TEXT NOT NULL,
  x           INTEGER NOT NULL,
  y           INTEGER NOT NULL,
  width       INTEGER NOT NULL,
  height      INTEGER NOT NULL,
  FOREIGN KEY (collection) REFERENCES Collection(id)
);

CREATE TABLE 'Product'
(
  id          INTEGER PRIMARY KEY,
  category    INTEGER NOT NULL,
  name        TEXT NOT NULL,
  FOREIGN KEY (category) REFERENCES Category(id)
);

CREATE TABLE 'Attribute'
(
  id          INTEGER PRIMARY KEY,
  category    INTEGER NOT NULL,
  name        TEXT NOT NULL,
  FOREIGN KEY (category) REFERENCES Category(id)
);


CREATE TABLE 'Item'
(
  id        INTEGER PRIMARY KEY ASC,
  attribute INTEGER NOT NULL,
  name      TEXT NOT NULL,
  image     TEXT NOT NULL,
  FOREIGN KEY (attribute) REFERENCES Attribute(id)
);

-- N-N relations
CREATE TABLE 'SetProduct'
(
  'set'       INTEGER NOT NULL,
  'product'   INTEGER NOT NULL,
  PRIMARY KEY ('set', 'product')
);

CREATE TABLE 'ProductItem'
(
  product   INTEGER NOT NULL,
  item      INTEGER NOT NULL,
  PRIMARY KEY (item, product)
);
