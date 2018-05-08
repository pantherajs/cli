/**
 * @file bin/cli.js
 * @todo Unit tests for this. Bit pointless, but might as well.
 */
'use strict';

const dotenv = require('dotenv');
const path   = require('path');
const yargs  = require('yargs');

const pkg = require('../package.json');

dotenv.config();

/**
 * @type {Yargs}
 */
module.exports = yargs.commandDir(path.join(__dirname, 'commands'))
  .help('h')
  .alias('h', 'help')
  .version(`panthera-cli@${pkg.version}`)
  .alias('v', 'version')
  .demandCommand()
  .strict();
