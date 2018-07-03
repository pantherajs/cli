/**
 * @file test/tasks/sql/functions/category-view.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const categoryView = proxyquire('../../../../bin/tasks/sql/functions/category-view', stubs);

test('should create `category_view` function', async t => {
  await t.notThrows(() => categoryView.task({}));
});
