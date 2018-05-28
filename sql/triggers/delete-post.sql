CREATE OR REPLACE FUNCTION delete_post()
RETURNS TRIGGER AS
$delete_post$
BEGIN
  UPDATE topic_statistics_mat SET
    expiry = '-infinity'
  WHERE topic_id = OLD.topic_id
    AND OLD.created <= expiry;

  UPDATE forum_statistics_mat SET
    expiry = '-infinity'
  WHERE forum_id IN ((
    SELECT ancestor_forums((
      SELECT
        topic.forum_id
      FROM topic
      WHERE topic.id = OLD.topic_id
    ))
  ))
    AND OLD.created <= expiry;

  RETURN OLD;
END;
$delete_post$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER delete_post AFTER DELETE ON post
  FOR EACH ROW EXECUTE PROCEDURE delete_post();
