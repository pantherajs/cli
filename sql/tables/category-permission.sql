CREATE TABLE IF NOT EXISTS category_permission (
  id            SERIAL  NOT NULL,
  permission_id INTEGER NOT NULL,
  category_id   INTEGER NOT NULL,
  CONSTRAINT category_permission_primary_key
    PRIMARY KEY (id),
  CONSTRAINT category_permission_foreign_key_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permission(id)
    ON DELETE CASCADE,
  CONSTRAINT category_permission_foreign_key_category_id
    FOREIGN KEY (category_id)
    REFERENCES category(id)
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX category_permission_unique_index_permission_id
  ON category_permission(permission_id);
CREATE INDEX category_permission_index_category_id
  ON category_permission(category_id);

GRANT USAGE, SELECT ON SEQUENCE category_permission_id_seq TO %I;
GRANT SELECT, INSERT ON category_permission TO %I;
