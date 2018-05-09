/**
 * @file bin/tasks/sql/tables/alias.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `alias` table...';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => {
  const user = ctx.env.PANTHERA_API_USER;

  return sqlTask(ctx, 'tables/alias.sql', user, user);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
