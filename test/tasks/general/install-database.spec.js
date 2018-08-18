/**
 * @file test/tasks/general/install-database.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  listr: function() {}
};

const include = proxyquire('../../../bin/tasks/general/install-database', stubs);

test('should only be enabled if `ctx.connected` is true', t => {
  const context = {};

  context.connected = true;
  t.true(include.enabled(context));

  context.connected = false;
  t.false(include.enabled(context));
});

test('should begin installing the database', t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  const result = include.task(context, task);
  t.true(result instanceof stubs.listr);
});
