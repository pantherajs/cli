CREATE TABLE IF NOT EXISTS category (
  id       SERIAL                   NOT NULL,
  name     CHARACTER VARYING(64)    NOT NULL,
  sort_key INTEGER                  NOT NULL DEFAULT 0,
  created  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT category_primary_key
    PRIMARY KEY (id),
  CONSTRAINT category_unique_name
    UNIQUE (name)
);

CREATE TRIGGER update_category_modified BEFORE UPDATE ON category
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE category_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON category TO %I;
