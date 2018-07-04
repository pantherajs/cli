CREATE TABLE IF NOT EXISTS permission (
  id              SERIAL                   NOT NULL,
  role_id         INTEGER                  NOT NULL,
  permission_type PERMISSION_TYPE          NOT NULL,
  resource_type   RESOURCE_TYPE            NOT NULL,
  state           BOOLEAN                  NOT NULL DEFAULT FALSE,
  created         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT permission_primary_key
    PRIMARY KEY (id),
  CONSTRAINT permission_foreign_key_role_id
    FOREIGN KEY (role_id)
    REFERENCES role(id)
    ON DELETE CASCADE
);

CREATE INDEX permission_index_role_id
  ON permission(role_id);
CREATE INDEX permission_index_permission_type
  ON permission(permission_type);
CREATE INDEX permission_index_resource_type
  ON permission(resource_type);

CREATE TRIGGER update_permission_modified BEFORE UPDATE ON permission
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE permission_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON permission TO %I;
