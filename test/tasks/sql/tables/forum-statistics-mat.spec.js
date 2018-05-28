/**
 * @file test/tasks/sql/tables/forum-statistics-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const forum = proxyquire('../../../../bin/tasks/sql/tables/forum-statistics-mat', stubs);

test('should create `forum_statistics_mat` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => forum.task(context));
});
