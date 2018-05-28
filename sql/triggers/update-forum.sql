CREATE OR REPLACE FUNCTION update_forum()
RETURNS TRIGGER AS
$update_forum$
BEGIN
  IF (OLD.parent_forum_id IS DISTINCT FROM NEW.parent_forum_id) THEN
    IF (OLD.parent_forum_id IS NOT NULL) THEN
      UPDATE forum_statistics_mat SET
        expiry = NEW.created -- NEW.modified?
      WHERE forum_id IN (SELECT ancestor_forums(OLD.parent_forum_id));
    END IF;

    IF (NEW.parent_forum_id IS NOT NULL) THEN
      UPDATE forum_statistics_mat SET
        expiry = NEW.created -- NEW.modified?
      WHERE forum_id IN (SELECT ancestor_forums(NEW.parent_forum_id));
    END IF;
  END IF;

  RETURN NEW;
END;
$update_forum$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_forum AFTER UPDATE ON forum
  FOR EACH ROW EXECUTE PROCEDURE update_forum();
