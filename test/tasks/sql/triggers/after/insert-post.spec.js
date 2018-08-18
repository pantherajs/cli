/**
 * @file test/tasks/sql/triggers/after/insert-post.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../../bin/tasks/sql/triggers/after/insert-post', stubs);

test('should create `insert_post` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
