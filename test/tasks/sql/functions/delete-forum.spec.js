/**
 * @file test/tasks/sql/functions/delete-forum.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const remove = proxyquire('../../../../bin/tasks/sql/functions/delete-forum', stubs);

test('should create `delete_forum` function', async t => {
  await t.notThrows(() => remove.task({}));
});
