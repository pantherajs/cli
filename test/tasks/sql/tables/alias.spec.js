/**
 * @file test/tasks/sql/tables/alias.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const alias = proxyquire('../../../../bin/tasks/sql/tables/alias', stubs);

test('should create `alias` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => alias.task(context));
});
