/**
 * @file test/tasks/sql/tables/alias-statistics-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const alias = proxyquire('../../../../bin/tasks/sql/tables/alias-statistics-mat', stubs);

test('should create `alias_statistics_mat` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => alias.task(context));
});
