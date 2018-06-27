/**
 * @file test/tasks/sql/tables/access-token.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const accessToken = proxyquire('../../../../bin/tasks/sql/tables/access-token', stubs);

test('should create `access_token` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => accessToken.task(context));
});
