CREATE TABLE IF NOT EXISTS forum_permission (
  id            SERIAL  NOT NULL,
  permission_id INTEGER NOT NULL,
  forum_id      INTEGER NOT NULL,
  CONSTRAINT forum_permission_primary_key
    PRIMARY KEY (id),
  CONSTRAINT forum_permission_foreign_key_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permission(id)
    ON DELETE CASCADE,
  CONSTRAINT forum_permission_foreign_key_forum_id
    FOREIGN KEY (forum_id)
    REFERENCES forum(id)
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX forum_permission_unique_index_permission_id
  ON forum_permission(permission_id);
CREATE INDEX forum_permission_index_forum_id
  ON forum_permission(forum_id);

GRANT USAGE, SELECT ON SEQUENCE forum_permission_id_seq TO %I;
GRANT SELECT, INSERT ON forum_permission TO %I;
