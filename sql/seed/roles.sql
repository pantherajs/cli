INSERT INTO role (name)
  SELECT UNNEST(
    ARRAY[
      'Administrator',
      'Member',
      'Character',
      'Guest'
    ]
  ) AS name;
