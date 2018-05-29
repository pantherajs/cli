/**
 * @file test/tasks/sql/functions/refresh-alias-statistics-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const uuid = proxyquire('../../../../bin/tasks/sql/functions/refresh-alias-statistics-mat', stubs);

test('should create `refresh_alias_statistics_mat` function', async t => {
  await t.notThrows(() => uuid.task({}));
});
