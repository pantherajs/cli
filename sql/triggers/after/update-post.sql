CREATE OR REPLACE FUNCTION update_post()
RETURNS TRIGGER AS
$update_post$
BEGIN
  IF (OLD.topic_id <> NEW.topic_id) THEN
    UPDATE topic_statistics_mat SET
      expiry = NEW.modified
    WHERE topic_statistics_mat.topic_id IN (OLD.topic_id, NEW.topic_id);

    UPDATE forum_statistics_mat SET
      expiry = NEW.modified
    WHERE forum_statistics_mat.forum_id IN (
      SELECT
        topic.forum_id
      FROM topic
      WHERE topic.id IN (OLD.topic_id, NEW.topic_id)
    );
  END IF;

  IF (OLD.author_alias_id <> NEW.author_alias_id) THEN
    UPDATE alias_statistics_mat SET
      expiry = NEW.modified
    WHERE alias_statistics_mat.alias_id IN (OLD.author_alias_id, NEW.author_alias_id);
  END IF;

  RETURN NEW;
END;
$update_post$
  LANGUAGE plpgsql;

CREATE TRIGGER update_post AFTER UPDATE ON post
  FOR EACH ROW EXECUTE PROCEDURE update_post();
