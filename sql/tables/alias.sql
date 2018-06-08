CREATE TABLE IF NOT EXISTS alias (
  id         SERIAL                       NOT NULL,
  account_id INTEGER                  DEFAULT NULL REFERENCES account(id),
  role_id    INTEGER                      NOT NULL REFERENCES role(id),
  name       CHARACTER VARYING(64)        NOT NULL UNIQUE,
  type       ALIAS_TYPE          NOT NULL DEFAULT 'SECONDARY',
  created    TIMESTAMP WITH TIME ZONE     NOT NULL DEFAULT now(),
  modified   TIMESTAMP WITH TIME ZONE     NOT NULL DEFAULT now(),
  CONSTRAINT alias_primary_key            PRIMARY KEY (id),
  CONSTRAINT alias_foreign_key_account_id FOREIGN KEY (account_id) REFERENCES account(id),
  CONSTRAINT alias_foreign_key_role_id    FOREIGN KEY (role_id)    REFERENCES role(id)
);

CREATE INDEX alias_index_account_id
  ON alias(account_id);
CREATE INDEX alias_index_role_id
  ON alias(role_id);
CREATE UNIQUE INDEX alias_unique_primary_alias
  ON alias(account_id, type) WHERE type = 'PRIMARY';

CREATE TRIGGER update_alias_modified BEFORE UPDATE ON alias
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT USAGE, SELECT ON SEQUENCE alias_id_seq TO %I;
GRANT SELECT, INSERT, UPDATE, DELETE ON alias TO %I;
