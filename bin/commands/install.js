/**
 * @file bin/commands/install.js
 */
'use strict';

const Listr   = require('listr');

const context = require('../utils/context');

const checkPostgres         = require('../tasks/general/check-postgres');
const checkEnvironment      = require('../tasks/general/check-environment');
const getCredentials        = require('../tasks/general/get-database-credentials');
const getConfiguration      = require('../tasks/general/get-configuration');
const connectToDatabase     = require('../tasks/general/connect-to-database');
const checkSchema           = require('../tasks/sql/misc/check-schema');
const shouldDropSchema      = require('../tasks/prompts/should-drop-schema');
const checkApiUser          = require('../tasks/sql/misc/check-api-user');
const installDatabase       = require('../tasks/general/install-database');
const disconnectDatabase    = require('../tasks/general/disconnect-from-database');

/**
 * @type {Array}
 */
const tasks = [
  checkPostgres,
  checkEnvironment,
  getCredentials,
  getConfiguration,
  connectToDatabase,
  checkSchema,
  shouldDropSchema,
  checkApiUser,
  installDatabase,
  disconnectDatabase
];

/**
 * @type {Object}
 */
const options = {
  exitOnError: false
};

/**
 * Note the empty catch error handler: errors are deliberately swallowed to
 * prevent Listr and Yargs from both attempting to handle displaying errors.
 * Errors will be written to a log file, not displayed in the output stream.
 * @return {Promise}
 * @private
 */
const handler = () => new Listr(tasks, options)
  .run(context())
  .catch(error => {});

/**
 * A Yargs-compatible command object.
 * @type {Object}
 */
module.exports = {
  aliases:  [ 'i' ],
  builder:  {},
  command:  'install',
  describe: 'Starts the database installer',
  handler
};
