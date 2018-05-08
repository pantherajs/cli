/**
 * @file bin/utils/sql-task.js
 */
'use strict';

const format = require('pg-format');
const path   = require('path');
const sander = require('sander');

/**
 * The directory containing raw SQL files to execute as part of any SQL task.
 * @type {String}
 */
const sqlDir = path.join(__dirname, '../../sql');

/**
 * Options for reading in files.
 * @type {Object}
 */
const options = {
  encoding: 'utf-8'
};

/**
 * Using the specified context object, reads the contents of the specified SQL
 * file and executes it against the database using the remaining arguments.
 * @param  {Object}    ctx
 * @param  {String}    file
 * @param  {...String} args
 * @return {Promise}
 * @private
 */
module.exports = (ctx, file, ...args) => {
  return sander.readFile(path.join(sqlDir, file), options)
    .then(sql => ctx.client.query(format.call(null, sql.trim(), ...args)))
    .catch(error => {
      ctx.error = true;
      return Promise.reject(error);
    });
};
