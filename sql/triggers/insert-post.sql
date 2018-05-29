CREATE OR REPLACE FUNCTION insert_post()
RETURNS TRIGGER AS
$insert_post$
BEGIN
  UPDATE topic_statistics_mat SET
    expiry = NEW.created
  WHERE topic_id = NEW.topic_id;

  UPDATE forum_statistics_mat SET
    expiry = NEW.created
  WHERE forum_id IN ((
    SELECT ancestor_forums((
      SELECT
        topic.forum_id
      FROM topic
      WHERE topic.id = NEW.topic_id
    ))
  ));

  UPDATE alias_statistics_mat SET
    expiry = NEW.created
  WHERE alias_id = NEW.author_alias_id;

  RETURN NEW;
END;
$insert_post$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_post AFTER INSERT ON post
  FOR EACH ROW EXECUTE PROCEDURE insert_post();
