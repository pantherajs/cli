/**
 * @file test/tasks/sql/triggers/insert-alias.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const insert = proxyquire('../../../../bin/tasks/sql/triggers/insert-alias', stubs);

test('should create `insert_alias` trigger', async t => {
  await t.notThrows(() => insert.task({}));
});
