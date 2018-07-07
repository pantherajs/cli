/**
 * @file test/tasks/sql/functions/topic-view.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const view = proxyquire('../../../../bin/tasks/sql/functions/topic-view', stubs);

test('should create `topic_view` function', async t => {
  await t.notThrows(() => view.task({}));
});
