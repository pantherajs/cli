CREATE OR REPLACE VIEW forum_view AS
  SELECT
    forum.id                         AS forum_id,
    forum.sort_key                   AS forum_sort_key,
    json_build_object(
      'forum_id',                 forum.id,
      'forum_name',               forum.name,
      'num_topics',               forum_statistics.num_topics,
      'num_posts',                forum_statistics.num_posts,
      'recent_topic_id',          topic.id,
      'recent_topic_title',       topic.title,
      'recent_topic_created',     topic.created,
      'recent_topic_author_id',   topic_author.id,
      'recent_topic_author_name', topic_author.name,
      'recent_post_id',           post.id,
      'recent_post_created',      post.created,
      'recent_post_author_id',    post_author.id,
      'recent_post_author_name',  post_author.name,
      'num_subforums',            COUNT(subforum.*),
      'subforums',                COALESCE(jsonb_agg(json_build_object(
          'subforum_id',   subforum.id,
          'subforum_name', subforum.name
        ) ORDER BY
          subforum.sort_key ASC,
          subforum.id ASC
        ) FILTER (WHERE subforum.id IS NOT NULL), '[]'::jsonb)
    )                                AS json_data
  FROM forum
  LEFT JOIN forum AS subforum
    ON forum.id = subforum.parent_forum_id
  INNER JOIN forum_statistics
    ON forum.id = forum_statistics.forum_id
  LEFT JOIN topic
    ON forum_statistics.recent_topic_id = topic.id
  LEFT JOIN alias AS topic_author
    ON topic.author_alias_id = topic_author.id
  LEFT JOIN post
    ON forum_statistics.recent_post_id = post.id
  LEFT JOIN alias AS post_author
    ON post.author_alias_id = post_author.id
  GROUP BY
    forum.id,
    forum.name,
    forum.sort_key,
    forum_statistics.num_topics,
    forum_statistics.num_posts,
    topic.id,
    topic.title,
    topic.created,
    topic_author.id,
    topic_author.name,
    post.id,
    post.created,
    post_author.id,
    post_author.name;

GRANT SELECT ON forum_view TO %I;
