/**
 * @file test/tasks/sql/tables/permission-forum.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const permissionForum = proxyquire('../../../../bin/tasks/sql/tables/permission-forum', stubs);

test('should create `permission_forum` table', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => permissionForum.task(context));
});
