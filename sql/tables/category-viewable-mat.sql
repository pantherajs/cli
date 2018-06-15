CREATE TABLE IF NOT EXISTS category_viewable_mat (
  account_id  INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  can_view    BOOLEAN NOT NULL DEFAULT FALSE,
  expiry      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT 'infinity',
  CONSTRAINT category_viewable_mat_primary_key
    PRIMARY KEY (account_id, category_id),
  CONSTRAINT category_viewable_mat_foreign_key_account_id
    FOREIGN KEY (account_id)
    REFERENCES account(id)
    ON DELETE CASCADE,
  CONSTRAINT category_viewable_mat_foreign_key_category_id
    FOREIGN KEY (category_id)
    REFERENCES category(id)
    ON DELETE CASCADE
);

CREATE INDEX category_viewable_mat_index_account_id
  ON category_viewable_mat(account_id);
CREATE INDEX category_viewable_mat_index_category_id
  ON category_viewable_mat(category_id);
CREATE INDEX category_viewable_mat_index_expiry
  ON category_viewable_mat(expiry ASC);

GRANT SELECT ON category_viewable_mat TO %I;
