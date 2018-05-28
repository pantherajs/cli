CREATE OR REPLACE FUNCTION delete_topic()
RETURNS TRIGGER AS
$delete_topic$
BEGIN
  UPDATE forum_statistics_mat SET
    expiry = '-infinity'
  WHERE forum_id IN (SELECT ancestor_forums(OLD.forum_id))
    AND OLD.created <= expiry;

  RETURN OLD;
END;
$delete_topic$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER delete_topic AFTER DELETE ON topic
  FOR EACH ROW EXECUTE PROCEDURE delete_topic();
