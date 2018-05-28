/**
 * @file test/tasks/sql/views/index.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const index = proxyquire('../../../../bin/tasks/sql/views/index', stubs);

test('should create `index` view', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => index.task(context));
});
