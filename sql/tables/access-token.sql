CREATE TABLE IF NOT EXISTS access_token (
  id         SERIAL                   NOT NULL,
  token      UUID                     NOT NULL DEFAULT uuid(),
  account_id INTEGER,
  issued     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  expires    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now() + (INTERVAL '1 DAY' * 30),
  CONSTRAINT access_token_primary_key
    PRIMARY KEY (id),
  CONSTRAINT access_token_foreign_key_account_id
    FOREIGN KEY (account_id)
    REFERENCES account(id)
    ON DELETE CASCADE
);

CREATE INDEX access_token_index_account_id
  ON access_token(account_id);
CREATE INDEX access_token_index_expires
  ON access_token(expires);

GRANT USAGE, SELECT ON SEQUENCE access_token_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON access_token TO %I;
