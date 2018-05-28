CREATE TABLE IF NOT EXISTS forum_statistics_mat (
  forum_id        INTEGER PRIMARY KEY,
  num_topics      INTEGER NOT NULL DEFAULT 0,
  num_posts       INTEGER NOT NULL DEFAULT 0,
  recent_topic_id INTEGER,
  recent_post_id  INTEGER,
  expiry          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT 'infinity',
  CONSTRAINT forum_statistics_mat_foreign_key_forum_id
    FOREIGN KEY (forum_id)
    REFERENCES forum(id)
    ON DELETE CASCADE,
  CONSTRAINT forum_statistics_mat_positive_num_topics
    CHECK (num_topics >= 0),
  CONSTRAINT forum_statistics_mat_positive_num_posts
    CHECK (num_posts >= 0),
  CONSTRAINT forum_statistics_mat_foreign_key_recent_topic_id
    FOREIGN KEY (recent_topic_id)
    REFERENCES topic(id)
    ON DELETE SET NULL,
  CONSTRAINT forum_statistics_mat_foreign_key_recent_post_id
    FOREIGN KEY (recent_post_id)
    REFERENCES post(id)
    ON DELETE SET NULL
);

CREATE INDEX forum_statistics_mat_index_recent_topic_id
  ON forum_statistics_mat(recent_topic_id);
CREATE INDEX forum_statistics_mat_index_recent_post_id
  ON forum_statistics_mat(recent_post_id);
CREATE INDEX forum_statistics_mat_index_expiry
  ON forum_statistics_mat(expiry ASC);

GRANT SELECT ON forum_statistics_mat TO %I;
