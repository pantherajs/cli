/**
 * @file bin/tasks/prompts/get-api-password.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter API password';

/**
 * Prompts for the password of the database user the API will use. Intended to
 * run in a series of subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(3 of 3)');

  return input('Password: ', {
    secret:   true,
    validate: result => result.length > 0,
    done:     result => {
      ctx.api.password = result;
      task.title = pad(title, 'done');
      delete ctx.parent;
    }
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
