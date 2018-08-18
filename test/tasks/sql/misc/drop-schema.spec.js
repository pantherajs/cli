/**
 * @file test/tasks/sql/misc/drop-schema.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/query-enabled': sinon.stub().returns(true),
  '../../../utils/sql-task':      sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/misc/drop-schema', stubs);

test('should be enabled only if `ctx.dropSchema` is true', t => {
  t.true(include.enabled({
    dropSchema: true
  }));

  t.false(include.enabled({
    dropSchema: false
  }));
});

test('should drop schema', async t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    },
    schemaExists: true
  };
  const task = {};

  await include.task(context, task);
  t.false(context.schemaExists);
});
