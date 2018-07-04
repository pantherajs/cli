/**
 * @file test/tasks/sql/tables/permission.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const permission = proxyquire('../../../../bin/tasks/sql/tables/permission', stubs);

test('should create `permission` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => permission.task(context));
});
