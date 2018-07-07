/**
 * @file test/tasks/sql/functions/update-category.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const update = proxyquire('../../../../bin/tasks/sql/functions/update-category', stubs);

test('should create `update_category` function', async t => {
  await t.notThrows(() => update.task({}));
});
