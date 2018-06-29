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

  INSERT INTO forum_permission(forum_id, role_id)
    SELECT
      NEW.id,
      role.id
    FROM role;

  RETURN NEW;
END;
$insert_forum$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_forum AFTER INSERT ON forum
  FOR EACH ROW EXECUTE PROCEDURE insert_forum();
