/**
 * @file test/tasks/sql/functions/refresh-category-viewable-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const uuid = proxyquire('../../../../bin/tasks/sql/functions/refresh-category-viewable-mat', stubs);

test('should create `refresh_category_viewable_mat` function', async t => {
  await t.notThrows(() => uuid.task({}));
});
