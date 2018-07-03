/**
 * @file test/tasks/sql/functions/forum-view.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const forumView = proxyquire('../../../../bin/tasks/sql/functions/forum-view', stubs);

test('should create `forum_view` function', async t => {
  await t.notThrows(() => forumView.task({}));
});
