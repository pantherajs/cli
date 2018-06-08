CREATE TABLE IF NOT EXISTS category_permission (
  category_id INTEGER                  NOT NULL,
  role_id     INTEGER                  NOT NULL,
  can_view    BOOLEAN                  NOT NULL DEFAULT FALSE,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  PRIMARY KEY (category_id, role_id),
  CONSTRAINT category_permission_foreign_key_category_id
    FOREIGN KEY (category_id)
    REFERENCES category(id),
  CONSTRAINT category_permission_foreign_key_role_id
    FOREIGN KEY (role_id)
    REFERENCES role(id)
);

CREATE INDEX category_permission_index_forum_id
  ON category_permission(category_id);
CREATE INDEX category_permission_index_role_id
  ON category_permission(role_id);
CREATE INDEX category_permission_index_can_view
  ON category_permission(can_view);

CREATE TRIGGER update_category_permission_modified BEFORE UPDATE ON category_permission
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON category_permission TO %I;
