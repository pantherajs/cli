/**
 * @file bin/tasks/sql/misc/create-schema.js
 */
'use strict';

const queryEnabled = require('../../../utils/query-enabled');
const sqlTask      = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating schema...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx) && ctx.schemaExists === false;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  task.title = `Creating schema \`${schema}\`...`;

  return sqlTask(ctx, 'misc/create-schema.sql', schema);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
