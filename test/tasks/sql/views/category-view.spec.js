/**
 * @file test/tasks/sql/views/category-view.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const category = proxyquire('../../../../bin/tasks/sql/views/category-view', stubs);

test('should create `category` view', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => category.task(context));
});
