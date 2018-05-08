/**
 * @file bin/tasks/sql/misc/check-schema.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const pad     = require('../../../utils/pad');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Checking schema...';

/**
 * @type {String}
 */
const file = 'misc/check-schema.sql';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  task.title = `Checking schema \`${schema}\`...`;

  return sqlTask(ctx, file, schema).then(result => {
    ctx.schemaExists = result.rows[0].exists;
    task.title = pad(task.title, (ctx.schemaExists) ? 'found' : 'not found');
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
