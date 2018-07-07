/**
 * @file test/tasks/sql/functions/create-category.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const create = proxyquire('../../../../bin/tasks/sql/functions/create-category', stubs);

test('should create `create_category` function', async t => {
  await t.notThrows(() => create.task({}));
});
