/**
 * @file test/tasks/sql/functions/refresh-topic-statistics-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const uuid = proxyquire('../../../../bin/tasks/sql/functions/refresh-topic-statistics-mat', stubs);

test('should create `refresh_topic_statistics_mat` function', async t => {
  await t.notThrows(() => uuid.task({}));
});
