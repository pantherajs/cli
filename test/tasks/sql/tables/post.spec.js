/**
 * @file test/tasks/sql/tables/post.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const post = proxyquire('../../../../bin/tasks/sql/tables/post', stubs);

test('should create `post` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => post.task(context));
});
