/**
 * @file bin/tasks/install/check-postgres.js
 */
'use strict';

const execa  = require('execa');
const semver = require('semver');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Checking PostgreSQL version...';

/**
 * Ensures a supported version of PostgreSQL is installed on the local system.
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  return execa('pg_config', [ '--version' ]).then(result => {
    return result.stdout.split(' ')[1];
  }).catch(() => {
    task.title = pad(title, 'not found');

    return Promise.reject(new Error('PostgreSQL not found'));
  }).then(version => {
    task.title  = pad(title, `${version} detected`);
    ctx.version = version;

    if (!semver.satisfies(semver.coerce(version), '>=10.x')) {
      return Promise.reject(new Error('PostgreSQL >=10.x required'));
    }
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
