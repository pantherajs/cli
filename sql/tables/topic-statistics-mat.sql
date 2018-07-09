CREATE TABLE IF NOT EXISTS topic_statistics_mat (
  topic_id       INTEGER                  NOT NULL,
  num_posts      INTEGER                  NOT NULL DEFAULT 0,
  recent_post_id INTEGER                           DEFAULT NULL,
  expiry         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT 'infinity',
  CONSTRAINT topic_statistics_mat_primary_key
    PRIMARY KEY (topic_id),
  CONSTRAINT topic_statistics_mat_foreign_key_topic_id
    FOREIGN KEY (topic_id)
    REFERENCES topic(id)
    ON DELETE CASCADE,
  CONSTRAINT topic_statistics_mat_positive_num_posts
    CHECK (num_posts >= 0),
  CONSTRAINT topic_statistics_mat_foreign_key_recent_post_id
    FOREIGN KEY (recent_post_id)
    REFERENCES post(id)
    ON DELETE SET NULL
);

CREATE INDEX topic_statistics_mat_index_recent_post_id
  ON topic_statistics_mat(recent_post_id);
CREATE INDEX topic_statistics_mat_index_expiry
  ON topic_statistics_mat(expiry ASC);

GRANT SELECT, INSERT, UPDATE ON topic_statistics_mat TO %I;
