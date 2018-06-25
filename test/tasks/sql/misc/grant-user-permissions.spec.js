/**
 * @file test/tasks/sql/misc/grant-user-permissions.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const grant = proxyquire('../../../../bin/tasks/sql/misc/grant-user-permissions', stubs);

test('should be enabled only if client can query', async t => {
  t.true(grant.enabled({
    client: {
      readyForQuery: true
    }
  }));
  t.false(grant.enabled({
    client: {
      readyForQuery: false
    }
  }));
});

test('should grant user permissions', async t => {
  const context = {
    env: {
      PANTHERA_SCHEMA:   'schema',
      PANTHERA_API_USER: 'panthera_api'
    }
  };

  await t.notThrows(() => grant.task(context, { title: 'task' }));
});
