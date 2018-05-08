/**
 * @file bin/tasks/prompts/get-schema.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter database schema';

/**
 * Prompts for the schema to install into and that the API will use. Intended
 * to run in a series of subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  ctx.api = {};

  const { task, title } = ctx.parent;
  task.title = pad(title, '(1 of 3)');

  return input('Schema: ', {
    secret:   true,
    validate: result => result.length > 0,
    done:     result => ctx.env.PANTHERA_SCHEMA = result
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
