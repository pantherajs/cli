/**
 * @file bin/tasks/sql/views/index-view.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `index_view` view...';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => {
  const user = ctx.env.PANTHERA_API_USER;

  return sqlTask(ctx, 'views/index-view.sql', user);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
