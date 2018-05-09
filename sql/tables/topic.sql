CREATE TABLE IF NOT EXISTS topic (
  id              SERIAL                   NOT NULL,
  forum_id        INTEGER                  NOT NULL,
  author_alias_id INTEGER                  NOT NULL,
  title           CHARACTER VARYING(64)    NOT NULL,
  created         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT topic_primary_key                 PRIMARY KEY (id),
  CONSTRAINT topic_foreign_key_forum_id        FOREIGN KEY (forum_id)        REFERENCES forum(id),
  CONSTRAINT topic_foreign_key_author_alias_id FOREIGN KEY (author_alias_id) REFERENCES alias(id)
);

CREATE INDEX topic_index_category_id     ON topic(forum_id);
CREATE INDEX topic_index_author_alias_id ON topic(author_alias_id);

CREATE TRIGGER update_topic_modified BEFORE UPDATE ON topic
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE topic_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON topic TO %I;
