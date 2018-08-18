/**
 * @file test/tasks/sql/tables/category.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/tables/category', stubs);

test('should create `category` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => include.task(context));
});
