/**
 * @file bin/tasks/sql/functions/refresh-forum-viewable-mat.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `refresh_forum_viewable_mat` function...';

/**
 * @type {String}
 */
const file = 'functions/refresh-forum-viewable-mat.sql';

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
