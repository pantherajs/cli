/**
 * @file test/tasks/sql/functions/index-view.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const indexView = proxyquire('../../../../bin/tasks/sql/functions/index-view', stubs);

test('should create `index_view` function', async t => {
  await t.notThrows(() => indexView.task({}));
});
