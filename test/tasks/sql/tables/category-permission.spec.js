/**
 * @file test/tasks/sql/tables/category-permission.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const category = proxyquire('../../../../bin/tasks/sql/tables/category-permission', stubs);

test('should create `category` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => category.task(context));
});
