/**
 * @file test/tasks/sql/seed/roles.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const roles = proxyquire('../../../../bin/tasks/sql/seed/roles', stubs);

test('should seed default roles', async t => {
  await t.notThrows(() => roles.task({}));
});
