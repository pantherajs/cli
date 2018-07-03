CREATE OR REPLACE FUNCTION insert_topic()
RETURNS TRIGGER AS
$insert_topic$
BEGIN
  INSERT INTO topic_statistics_mat (topic_id) VALUES (NEW.id);

  UPDATE forum_statistics_mat SET
    expiry = NEW.created
  WHERE forum_id = NEW.forum_id;

  UPDATE alias_statistics_mat SET
    expiry = NEW.created
  WHERE alias_id = NEW.author_alias_id;

  RETURN NEW;
END;
$insert_topic$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_topic AFTER INSERT ON topic
  FOR EACH ROW EXECUTE PROCEDURE insert_topic();
