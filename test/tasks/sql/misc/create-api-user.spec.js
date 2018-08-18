/**
 * @file test/tasks/sql/misc/create-api-user.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/query-enabled': sinon.stub().returns(true),
  '../../../utils/sql-task':      sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/misc/create-api-user', stubs);

test('should be enabled if the client can query and `ctx.apiUserExists` is false', t => {
  const context = {
    apiUserExists: false
  };

  t.true(include.enabled(context));
});

test('should create the API user', async t => {
  const context = {
    env: {
      PANTHERA_SCHEMA:   'schema',
      PANTHERA_API_USER: 'user',
      PANTHERA_API_PASS: 'password'
    }
  };
  const task = {};

  await include.task(context, task);
  t.pass();
});
