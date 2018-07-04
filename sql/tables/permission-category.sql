CREATE TABLE IF NOT EXISTS permission_category (
  id            SERIAL  NOT NULL,
  permission_id INTEGER NOT NULL,
  category_id   INTEGER NOT NULL,
  CONSTRAINT permission_category_primary_key
    PRIMARY KEY (id),
  CONSTRAINT permission_category_foreign_key_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permission(id)
    ON DELETE CASCADE,
  CONSTRAINT permission_category_foreign_key_category_id
    FOREIGN KEY (category_id)
    REFERENCES category(id)
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX permission_category_unique_index_permission_id
  ON permission_category(permission_id);
CREATE INDEX permission_category_index_category_id
  ON permission_category(category_id);

GRANT USAGE, SELECT ON SEQUENCE permission_category_id_seq TO %I;
GRANT SELECT, INSERT ON permission_category TO %I;
