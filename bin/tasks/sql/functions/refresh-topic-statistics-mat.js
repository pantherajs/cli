/**
 * @file bin/tasks/sql/functions/refresh-topic-statistics-mat.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `refresh_topic_statistics_mat` function...';

/**
 * @type {String}
 */
const file = 'functions/refresh-topic-statistics-mat.sql';

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
