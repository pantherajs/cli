/**
 * @file bin/tasks/sql/functions/uuid.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `uuid` function...';

/**
 * @type {String}
 */
const file = 'functions/uuid.sql';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => sqlTask(ctx, file);

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
