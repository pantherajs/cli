/**
 * @file test/tasks/sql/functions/update-forum.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const update = proxyquire('../../../../bin/tasks/sql/functions/update-forum', stubs);

test('should create `update_forum` function', async t => {
  await t.notThrows(() => update.task({}));
});
