CREATE TABLE IF NOT EXISTS alias_statistics_mat (
  alias_id        INTEGER                  NOT NULL,
  num_topics      INTEGER                  NOT NULL DEFAULT 0,
  num_posts       INTEGER                  NOT NULL DEFAULT 0,
  recent_post_id  INTEGER                           DEFAULT NULL,
  expiry          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT 'infinity',
  CONSTRAINT alias_statistics_mat_primary_key
    PRIMARY KEY (alias_id),
  CONSTRAINT alias_statistics_mat_foreign_key_alias_id
    FOREIGN KEY (alias_id)
    REFERENCES alias (id)
    ON DELETE CASCADE,
  CONSTRAINT alias_statistics_mat_positive_num_topics
    CHECK (num_topics >= 0),
  CONSTRAINT alias_statistics_mat_positive_num_posts
    CHECK (num_posts >= 0),
  CONSTRAINT forum_statistics_mat_foreign_key_recent_post_id
    FOREIGN KEY (recent_post_id)
    REFERENCES post(id)
    ON DELETE SET NULL
);

CREATE INDEX alias_statistics_mat_index_expiry
  ON alias_statistics_mat(expiry ASC);

GRANT SELECT, INSERT, UPDATE ON alias_statistics_mat TO %I;
