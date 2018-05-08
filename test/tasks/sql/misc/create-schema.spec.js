/**
 * @file test/tasks/sql/misc/create-schema.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/query-enabled': sinon.stub().returns(true),
  '../../../utils/sql-task':      sinon.stub().resolves()
};

const create = proxyquire('../../../../bin/tasks/sql/misc/create-schema', stubs);

test('should be enabled if the client can query and `ctx.schemaExists` is false', t => {
  const context = {
    schemaExists: false
  };

  t.true(create.enabled(context));
});

test('should create the schema', async t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    },
  };
  const task = {};

  await create.task(context, task);
  t.pass();
});
