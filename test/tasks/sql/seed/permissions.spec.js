/**
 * @file test/tasks/sql/seed/permissions.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const permissions = proxyquire('../../../../bin/tasks/sql/seed/permissions', stubs);

test('should seed default permissions', async t => {
  await t.notThrows(() => permissions.task({}));
});
