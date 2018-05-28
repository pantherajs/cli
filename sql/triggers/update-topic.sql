CREATE OR REPLACE FUNCTION update_topic()
RETURNS TRIGGER AS
$update_topic$
BEGIN
  IF (OLD.forum_id <> NEW.forum_id) THEN
    UPDATE forum_statistics_mat SET
      expiry = NEW.created -- NEW.modified?
    WHERE forum_id IN ((
      SELECT ancestor_forums(OLD.forum_id)
      UNION ALL
      SELECT ancestor_forums(NEW.forum_id)
    ));
  END IF;

  RETURN NEW;
END;
$update_topic$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_topic AFTER UPDATE ON topic
  FOR EACH ROW EXECUTE PROCEDURE update_topic();
