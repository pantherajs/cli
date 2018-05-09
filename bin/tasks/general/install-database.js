/**
 * @file bin/tasks/general/install-database.js
 */
'use strict';

const Listr = require('listr');

const beginTransaction      = require('../sql/misc/begin-transaction');
const dropSchema            = require('../sql/misc/drop-schema');
const createSchema          = require('../sql/misc/create-schema');
const createApiUser         = require('../sql/misc/create-api-user');
const setSearchPath         = require('../sql/misc/set-search-path');
const uuidFunction          = require('../sql/functions/uuid');
const aliasType             = require('../sql/types/alias-type');
const updateModifiedTrigger = require('../sql/triggers/update-modified-column');
const accountTable          = require('../sql/tables/account');
const roleTable             = require('../sql/tables/role');
const aliasTable            = require('../sql/tables/alias');
const categoryTable         = require('../sql/tables/category');
const forumTable            = require('../sql/tables/forum');
const topicTable            = require('../sql/tables/topic');
const postTable             = require('../sql/tables/post');
const categoryPermTable     = require('../sql/tables/category-permission');
const forumPermTable        = require('../sql/tables/forum-permission');
const commitTransaction     = require('../sql/misc/commit-transaction');
const rollbackTransaction   = require('../sql/misc/rollback-transaction');

/**
 * @type {Array.<Object>}
 */
const tasks = [
  beginTransaction,
  dropSchema,
  createSchema,
  createApiUser,
  setSearchPath,
  uuidFunction,
  aliasType,
  updateModifiedTrigger,
  accountTable,
  roleTable,
  aliasTable,
  categoryTable,
  forumTable,
  topicTable,
  postTable,
  categoryPermTable,
  forumPermTable,
  commitTransaction,
  rollbackTransaction
];

/**
 * @type {String}
 */
const title = 'Installing database...';

/**
 * @param  {Object} ctx
 * @return {Boolan}
 * @private
 */
const enabled = ctx => ctx.connected === true;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Listr}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  ctx.parent = {
    start: process.hrtime(),
    title: `Installing database into \`${schema}\`...`,
    task
  };

  task.title = ctx.parent.title;

  return new Listr(tasks);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
