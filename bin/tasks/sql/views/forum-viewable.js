/**
 * @file bin/tasks/sql/views/forum-viewable.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `forum_viewable` view...';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => {
  const user = ctx.env.PANTHERA_API_USER;

  return sqlTask(ctx, 'views/forum-viewable.sql', user);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
