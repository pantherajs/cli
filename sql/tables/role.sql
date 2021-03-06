CREATE TABLE IF NOT EXISTS role (
  id       SERIAL                   NOT NULL,
  name     CHARACTER VARYING(64)    NOT NULL,
  created  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT role_primary_key
    PRIMARY KEY (id),
  CONSTRAINT role_unique_name
    UNIQUE (name)
);

CREATE TRIGGER update_role_modified BEFORE UPDATE ON role
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE role_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON role TO %I;
