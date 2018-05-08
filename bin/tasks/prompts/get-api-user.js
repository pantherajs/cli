/**
 * @file bin/tasks/prompts/get-api-user.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter API user';

/**
 * Prompts for the name of the database user the API will use. Intended to run
 * in a series of subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(2 of 3)');

  return input('User: ', {
    default:  'panthera_api',
    validate: result => result.length > 0,
    done:     result => ctx.api.user = result
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
