/**
 * @file test/tasks/sql/tables/account.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const account = proxyquire('../../../../bin/tasks/sql/tables/account', stubs);

test('should create `account` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => account.task(context));
});