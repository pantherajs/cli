/**
 * @file test/tasks/sql/misc/check-api-user.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub()
};

const stub = stubs['../../../utils/sql-task'];

const include = proxyquire('../../../../bin/tasks/sql/misc/check-api-user', stubs);

test.serial('should set `ctx.apiUserExists` to true if API user exists', async t => {
  stub.resolves({
    rows: [{
        exists: true
    }]
  });

  const context = {
    client: {
      query: () => Promise.resolve()
    },
    env: {
      PANTHERA_API_USER: 'user'
    },
    sql: 'dir'
  };
  const task = {};

  await include.task(context, task);
  t.true(context.apiUserExists);

  stub.reset();
});

test.serial('should set `ctx.apiUserExists` to false if API user does not exist', async t => {
  stub.resolves({
    rows: [{
        exists: false
    }]
  });

  const context = {
    client: {
      query: () => Promise.resolve()
    },
    env: {
      PANTHERA_API_USER: 'user'
    },
    sql: 'dir'
  };
  const task = {};

  await include.task(context, task);
  t.false(context.apiUserExists);

  stub.reset();
});
