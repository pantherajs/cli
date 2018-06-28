/**
 * @file test/tasks/sql/tables/forum-viewable-mat.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const forum = proxyquire('../../../../bin/tasks/sql/tables/forum-viewable-mat', stubs);

test('should create `forum_viewable_mat` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => forum.task(context));
});
