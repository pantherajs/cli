/**
 * @file test/tasks/sql/tables/permission-category.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const permissionCategory = proxyquire('../../../../bin/tasks/sql/tables/permission-category', stubs);

test('should create `permission_category` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => permissionCategory.task(context));
});
