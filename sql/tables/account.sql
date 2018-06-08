CREATE TABLE IF NOT EXISTS account (
  id            SERIAL                   NOT NULL,
  email_address CHARACTER VARYING(256)   NOT NULL,
  password_hash CHARACTER(60)            NOT NULL,
  created       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT account_primary_key
    PRIMARY KEY (id),
  CONSTRAINT account_unique_email_address
    UNIQUE (email_address),
  CONSTRAINT account_valid_password_hash
    CHECK (password_hash ~ '^\$2[ayb]\$.{56}$')
);

CREATE TRIGGER update_account_modified BEFORE UPDATE ON account
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE account_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON account TO %I;
