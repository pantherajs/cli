CREATE TABLE IF NOT EXISTS forum (
  id              SERIAL                   NOT NULL,
  category_id     INTEGER                  NOT NULL,
  parent_forum_id INTEGER                           DEFAULT NULL,
  name            CHARACTER VARYING(64)    NOT NULL,
  sort_key        INTEGER                  NOT NULL DEFAULT 0,
  created         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT forum_primary_key
    PRIMARY KEY (id),
  CONSTRAINT forum_foreign_key_category_id
    FOREIGN KEY (category_id)
    REFERENCES category(id),
  CONSTRAINT forum_foreign_key_parent_forum_id
    FOREIGN KEY (parent_forum_id)
    REFERENCES forum(id),
  CONSTRAINT forum_unique_name
    UNIQUE (name)
);

CREATE INDEX forum_index_category_id
  ON forum(category_id);
CREATE INDEX forum_index_parent_forum_id
  ON forum(parent_forum_id ASC NULLS FIRST);

CREATE TRIGGER update_forum_modified BEFORE UPDATE ON forum
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE forum_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON forum TO %I;
