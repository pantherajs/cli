CREATE TABLE IF NOT EXISTS permission_forum (
  id            SERIAL  NOT NULL,
  permission_id INTEGER NOT NULL,
  forum_id      INTEGER NOT NULL,
  CONSTRAINT permission_forum_primary_key
    PRIMARY KEY (id),
  CONSTRAINT permission_forum_foreign_key_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permission(id)
    ON DELETE CASCADE,
  CONSTRAINT permission_forum_foreign_key_forum_id
    FOREIGN KEY (forum_id)
    REFERENCES forum(id)
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX permission_forum_unique_index_permission_id
  ON permission_forum(permission_id);
CREATE INDEX permission_forum_index_forum_id
  ON permission_forum(forum_id);

GRANT USAGE, SELECT ON SEQUENCE permission_forum_id_seq TO %I;
GRANT SELECT, INSERT ON permission_forum TO %I;
