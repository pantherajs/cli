/**
 * @file test/tasks/sql/misc/set-search-path.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/misc/set-search-path', stubs);

test('should set search path', async t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };

  await t.notThrows(() => include.task(context));
});
