CREATE OR REPLACE FUNCTION insert_forum()
RETURNS TRIGGER AS
$insert_forum$
BEGIN
  INSERT INTO forum_statistics_mat (forum_id) VALUES (NEW.id);

  IF (NEW.parent_forum_id IS NOT NULL) THEN
    UPDATE forum_statistics_mat SET
      expiry = NEW.created
    WHERE forum_statistics_mat.forum_id = NEW.id;
  END IF;

  INSERT INTO forum_viewable_mat (account_id, forum_id, expiry)
    SELECT
      account.id,
      NEW.id,
      NEW.created
    FROM account;

  INSERT INTO permission (role_id, permission_type, resource_type, enabled)
    SELECT
      role.id AS role_id,
      'READ'  AS permission_type,
      'FORUM' AS resource_type,
      FALSE   AS enabled
    FROM role
    UNION ALL
    SELECT
      role.id         AS role_id,
      permission.type AS permission_type,
      resource.type   AS resource_type,
      FALSE           AS enabled
    FROM role
    INNER JOIN (
      SELECT
        types.type
      FROM (
        SELECT
          unnest(enum_range(NULL::permission_type)) AS type
      ) AS types
      WHERE types.type NOT IN ('ACCESS', 'READ')
    ) AS permission
    CROSS JOIN (
      SELECT
        types.type
      FROM (
        SELECT
          unnest(enum_range(NULL::resource_type)) AS type
      ) AS types
      WHERE types.type IN ('TOPIC', 'POST')
    ) AS resource
    CROSS JOIN forum
      ON forum.id = NEW.id;

  INSERT INTO forum_permission (permission_id, forum_id)
    SELECT
      permission.id AS permission_id,
      NEW.id        AS forum_id
    FROM permission
    WHERE permission.id NOT IN (SELECT permission_id FROM forum_permission)
      AND permission.resource_type = 'FORUM'
      AND permission.permission_type = 'READ'
    UNION ALL
    SELECT
      permission.id AS permission_id,
      NEW.id        AS forum_id
    FROM permission
    WHERE permission.id NOT IN (SELECT permission_id FROM forum_permission)
      AND permission.resource_type IN ('TOPIC', 'POST')
      AND permission.permission_type IN ('CREATE', 'UPDATE', 'UPDATE_OWN', 'DELETE', 'DELETE_OWN');

  RETURN NEW;
END;
$insert_forum$
  LANGUAGE plpgsql;

CREATE TRIGGER insert_forum AFTER INSERT ON forum
  FOR EACH ROW EXECUTE PROCEDURE insert_forum();
