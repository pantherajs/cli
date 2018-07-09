/**
 * @file test/tasks/sql/triggers/after/update-alias.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const update = proxyquire('../../../../../bin/tasks/sql/triggers/after/update-alias', stubs);

test('should create `update_alias` trigger', async t => {
  await t.notThrows(() => update.task({}));
});
