/**
 * @file bin/tasks/sql/misc/create-api-user.js
 */
'use strict';

const pad          = require('../../../utils/pad');
const queryEnabled = require('../../../utils/query-enabled');
const since        = require('../../../utils/since');
const sqlTask      = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating API user...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx) && ctx.apiUserExists === false;

/**
 * @type {String}
 */
const file = 'misc/create-api-user.sql';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema   = ctx.env.PANTHERA_SCHEMA;
  const user     = ctx.env.PANTHERA_API_USER;
  const password = ctx.env.PANTHERA_API_PASS;

  task.title = `Creating API user \`${user}\`...`;

  const start = process.hrtime();

  return sqlTask(ctx, file, user, password, schema, user, user, schema)
    .then(() => task.title = pad(task.title, `${since(start)}ms`));
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
