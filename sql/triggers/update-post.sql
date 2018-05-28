CREATE OR REPLACE FUNCTION update_post()
RETURNS TRIGGER AS
$update_post$
BEGIN
  IF (OLD.topic_id <> NEW.topic_id) THEN
    UPDATE topic_statistics_mat SET
      expiry = NEW.created
    WHERE topic_id IN (OLD.topic_id, NEW.topic_id);

    UPDATE forum_statistics_mat SET
      expiry = NEW.created
    WHERE forum_id IN ((
      SELECT ancestor_forums((
        SELECT
          topic.forum_id
        FROM topic
        WHERE topic.id = OLD.topic_id
      ))
      UNION ALL
      SELECT ancestor_forums((
        SELECT
          topic.forum_id
        FROM topic
        WHERE topic.id = NEW.topic_id
      ))
    ));
  END IF;

  RETURN NEW;
END;
$update_post$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_post AFTER UPDATE ON post
  FOR EACH ROW EXECUTE PROCEDURE update_post();
