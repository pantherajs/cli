/**
 * @file test/tasks/sql/functions/get-post.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/functions/get-post', stubs);

test('should create `get_post` function', async t => {
  await t.notThrows(() => include.task({}));
});
