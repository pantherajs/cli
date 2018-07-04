CREATE OR REPLACE FUNCTION insert_forum()
RETURNS TRIGGER AS
$insert_forum$
BEGIN
  INSERT INTO forum_statistics_mat (forum_id) VALUES (NEW.id);

  IF (NEW.parent_forum_id IS NOT NULL) THEN
    UPDATE forum_statistics_mat SET
      expiry = NEW.created
    WHERE forum_id IN ((
      SELECT ancestor_forums(NEW.parent_forum_id)
    ));
  END IF;

  INSERT INTO forum_viewable_mat (account_id, forum_id, expiry)
    SELECT
      account.id,
      NEW.id,
      NEW.created
    FROM account;

  INSERT INTO permission (role_id, permission_type, resource_type, state)
    SELECT
      role.id AS role_id,
      'READ'  AS permission_type,
      'FORUM' AS resource_type,
      FALSE   AS state
    FROM role;

  INSERT INTO permission_forum (permission_id, forum_id)
    SELECT
      permission.id AS permission_id,
      NEW.id        AS forum_id
    FROM permission
    WHERE permission.id NOT IN (SELECT permission_id FROM permission_forum)
      AND permission.resource_type = 'FORUM'
      AND permission.permission_type = 'READ';

  RETURN NEW;
END;
$insert_forum$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_forum AFTER INSERT ON forum
  FOR EACH ROW EXECUTE PROCEDURE insert_forum();
