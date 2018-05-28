/**
 * @file test/tasks/sql/functions/ancestor-forums.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const uuid = proxyquire('../../../../bin/tasks/sql/functions/ancestor-forums', stubs);

test('should create `ancestor_forums` function', async t => {
  await t.notThrows(() => uuid.task({}));
});
