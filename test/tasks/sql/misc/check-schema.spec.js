/**
 * @file test/tasks/sql/misc/check-schema.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const stub = stubs['../../../utils/sql-task'];

const check = proxyquire('../../../../bin/tasks/sql/misc/check-schema', stubs);

test.serial('should set `ctx.schemaExists` to true if schema exists', async t => {
  stub.resolves({
    rows: [{
        exists: true
    }]
  });

  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  await check.task(context, task);
  t.true(context.schemaExists);

  stub.reset();
});

test.serial('should set `ctx.schemaExists` to false if schema does not exist', async t => {
  stub.resolves({
    rows: [{
        exists: false
    }]
  });

  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  await check.task(context, task);
  t.false(context.schemaExists);

  stub.reset();
});
