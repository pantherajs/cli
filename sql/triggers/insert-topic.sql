CREATE OR REPLACE FUNCTION insert_topic()
RETURNS TRIGGER AS
$insert_topic$
BEGIN
  INSERT INTO topic_statistics_mat (topic_id) VALUES (NEW.id);

  UPDATE forum_statistics_mat SET
    expiry = NEW.created
  WHERE forum_id IN (SELECT ancestor_forums(NEW.forum_id));

  RETURN NEW;
END;
$insert_topic$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_topic AFTER INSERT ON topic
  FOR EACH ROW EXECUTE PROCEDURE insert_topic();
