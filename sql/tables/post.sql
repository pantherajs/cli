CREATE TABLE IF NOT EXISTS post (
  id              SERIAL                   NOT NULL,
  topic_id        INTEGER                  NOT NULL,
  author_alias_id INTEGER                  NOT NULL,
  content         TEXT                     NOT NULL,
  created         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT post_primary_key
    PRIMARY KEY (id),
  CONSTRAINT post_foreign_key_topic_id
    FOREIGN KEY (topic_id)
    REFERENCES topic(id),
  CONSTRAINT post_foreign_key_author_alias_id
    FOREIGN KEY (author_alias_id)
    REFERENCES alias(id)
);

CREATE INDEX post_index_topic_id
  ON post(topic_id);
CREATE INDEX post_index_author_alias_id
  ON post(author_alias_id);

CREATE TRIGGER update_post_modified BEFORE UPDATE ON post
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE post_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON post TO %I;
