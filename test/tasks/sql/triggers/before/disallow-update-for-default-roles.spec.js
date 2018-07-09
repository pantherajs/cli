/**
 * @file test/tasks/sql/triggers/before/disallow-update-for-default-roles.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const update = proxyquire('../../../../../bin/tasks/sql/triggers/before/disallow-update-for-default-roles', stubs);

test('should create `disallow_update_for_default_roles` trigger', async t => {
  await t.notThrows(() => update.task({}));
});
