CREATE TABLE IF NOT EXISTS forum_permission (
  forum_id                INTEGER NOT NULL,
  role_id                 INTEGER NOT NULL,
  can_view                BOOLEAN NOT NULL DEFAULT FALSE,
  can_create_topic        BOOLEAN NOT NULL DEFAULT FALSE,
  can_create_post         BOOLEAN NOT NULL DEFAULT FALSE,
  can_edit_own_topics     BOOLEAN NOT NULL DEFAULT FALSE,
  can_edit_other_topics   BOOLEAN NOT NULL DEFAULT FALSE,
  can_delete_own_topics   BOOLEAN NOT NULL DEFAULT FALSE,
  can_delete_other_topics BOOLEAN NOT NULL DEFAULT FALSE,
  created  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  modified TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  PRIMARY KEY (forum_id, role_id),
  CONSTRAINT forum_permission_foreign_key_forum_id
    FOREIGN KEY (forum_id)
    REFERENCES forum(id),
  CONSTRAINT forum_permission_foreign_key_role_id
    FOREIGN KEY (role_id)
    REFERENCES role(id)
);

CREATE INDEX forum_permission_index_forum_id
  ON forum_permission(forum_id);
CREATE INDEX forum_permission_index_role_id
  ON forum_permission(role_id);
CREATE INDEX forum_permission_index_composite
  ON forum_permission(role_id, forum_id, can_view);

CREATE TRIGGER update_forum_permission_modified BEFORE UPDATE ON forum_permission
  FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON forum_permission TO %I;
