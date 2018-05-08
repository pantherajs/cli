/**
 * @file bin/tasks/sql/misc/set-search-path.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Setting search path...';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  return sqlTask(ctx, 'misc/set-search-path.sql', schema);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
