CREATE OR REPLACE FUNCTION delete_post()
RETURNS TRIGGER AS
$delete_post$
BEGIN
  UPDATE topic_statistics_mat SET
    expiry = '-infinity'
  WHERE topic_statistics_mat.topic_id = OLD.topic_id
    AND OLD.created <= topic_statistics_mat.expiry;

  UPDATE forum_statistics_mat SET
    expiry = '-infinity'
  WHERE forum_statistics_mat.forum_id = (
    SELECT
      topic.forum_id
    FROM topic
    WHERE topic.id = OLD.topic_id
  )
    AND OLD.created <= forum_statistics_mat.expiry;

  UPDATE alias_statistics_mat SET
    expiry = '-infinity'
  WHERE alias_statistics_mat.alias_id = OLD.author_alias_id
    AND OLD.created <= alias_statistics_mat.expiry;

  RETURN OLD;
END;
$delete_post$
  VOLATILE
  LANGUAGE plpgsql;

CREATE TRIGGER delete_post AFTER DELETE ON post
  FOR EACH ROW EXECUTE PROCEDURE delete_post();
