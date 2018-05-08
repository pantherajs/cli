/**
 * @file bin/tasks/sql/misc/drop-schema.js
 */
'use strict';

const queryEnabled = require('../../../utils/query-enabled');
const sqlTask      = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Dropping schema...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx) && ctx.dropSchema === true;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  task.title = `Dropping schema \`${schema}\`...`;

  return sqlTask(ctx, 'misc/drop-schema.sql', schema)
    .then(() => ctx.schemaExists = false);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
