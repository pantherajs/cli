CREATE OR REPLACE FUNCTION update_topic()
RETURNS TRIGGER AS
$update_topic$
BEGIN
  IF (OLD.forum_id <> NEW.forum_id) THEN
    UPDATE forum_statistics_mat SET
      expiry = NEW.modified?
    WHERE forum_statistics_mat.forum_id IN (OLD.forum_id, NEW.forum_id);
  END IF;

  IF (OLD.author_alias_id <> NEW.author_alias_id) THEN
    UPDATE alias_statistics_mat SET
      expiry = NEW.modified
    WHERE alias_statistics_mat.alias_id IN (OLD.author_alias_id, NEW.author_alias_id);
  END IF;

  RETURN NEW;
END;
$update_topic$
  LANGUAGE plpgsql;

CREATE TRIGGER update_topic AFTER UPDATE ON topic
  FOR EACH ROW EXECUTE PROCEDURE update_topic();
