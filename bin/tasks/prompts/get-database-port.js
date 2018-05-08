/**
 * @file bin/tasks/prompts/get-database-port.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter host';

/**
 * Prompts for the port to connect to. Intended to run in a series of subtasks,
 * hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(5 of 5)');

  return input('Host: ', {
    default:  '5432',
    validate: result => result.length > 0 && !isNaN(result),
    done:     result => {
      ctx.env.PANTHERA_DB_PORT = Number(result);
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
