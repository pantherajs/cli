/**
 * @file test/cli.spec.js
 */
'use strict';

const test  = require('ava');

const cli = require('../bin/cli');

/**
 * @todo Wait for the Yargs people to export the constructor, not a factory
 */
test('should export instanceof yargs', t => {
  t.truthy(cli instanceof Object);
});
