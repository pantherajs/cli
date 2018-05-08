/**
 * @file bin/tasks/sql/prompts/should-drop-schema.js
 */
'use strict';

const input = require('listr-input');

const pad          = require('../../utils/pad');
const queryEnabled = require('../../utils/query-enabled');

/**
 * @type {String}
 */
const title = 'Drop schema?';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx) && ctx.schemaExists === true;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  task.title = `Drop schema \`${schema}\`?`;

  return input('[Y/n]: ', {
    validate: result => RegExp(/^[Yn]{1}$/).test(result),
    done:     result => {
      ctx.dropSchema = result === 'Y';
      task.title = pad(task.title, ctx.dropSchema ? 'dropping' : 'keeping');
    }
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
