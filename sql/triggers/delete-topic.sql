CREATE OR REPLACE FUNCTION delete_topic()
RETURNS TRIGGER AS
$delete_topic$
BEGIN
  UPDATE forum_statistics_mat SET
    expiry = '-infinity'
  WHERE forum_statistics_mat.forum_id IN (SELECT ancestor_forums(OLD.forum_id))
    AND OLD.created <= forum_statistics_mat.expiry;

  UPDATE alias_statistics_mat SET
    expiry = '-infinity'
  WHERE alias_statistics_mat.alias_id = OLD.author_alias_id
    AND OLD.created <= alias_statistics_mat.expiry;

  RETURN OLD;
END;
$delete_topic$
  LANGUAGE plpgsql;

CREATE TRIGGER delete_topic AFTER DELETE ON topic
  FOR EACH ROW EXECUTE PROCEDURE delete_topic();
