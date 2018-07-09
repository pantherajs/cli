CREATE TABLE IF NOT EXISTS forum_viewable_mat (
  account_id INTEGER                  NOT NULL,
  forum_id   INTEGER                  NOT NULL,
  can_view   BOOLEAN                  NOT NULL DEFAULT FALSE,
  expiry     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT 'infinity',
  CONSTRAINT forum_viewable_mat_primary_key
    PRIMARY KEY (account_id, forum_id),
  CONSTRAINT forum_viewable_mat_foreign_key_account_id
    FOREIGN KEY (account_id)
    REFERENCES account(id)
    ON DELETE CASCADE,
  CONSTRAINT forum_viewable_mat_foreign_key_forum_id
    FOREIGN KEY (forum_id)
    REFERENCES forum(id)
    ON DELETE CASCADE
);

CREATE INDEX forum_viewable_mat_index_account_id
  ON forum_viewable_mat(account_id);
CREATE INDEX forum_viewable_mat_index_forum_id
  ON forum_viewable_mat(forum_id);
CREATE INDEX forum_viewable_mat_index_expiry
  ON forum_viewable_mat(expiry ASC);

GRANT SELECT, INSERT, UPDATE ON forum_viewable_mat TO %I;
