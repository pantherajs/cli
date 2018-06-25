/**
 * @file bin/tasks/sql/misc/grant-user-permissions.js
 */
'use strict';

const pad          = require('../../../utils/pad');
const queryEnabled = require('../../../utils/query-enabled');
const since        = require('../../../utils/since');
const sqlTask      = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Granting API user permissions...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx);

/**
 * @type {String}
 */
const file = 'misc/grant-user-permissions.sql';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;
  const user   = ctx.env.PANTHERA_API_USER;

  const start = process.hrtime();

  return sqlTask(ctx, file, schema, user, user, schema)
    .then(() => task.title = pad(task.title, `${since(start)}ms`));
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
