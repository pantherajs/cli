/**
 * @file bin/utils/since.js
 */
'use strict';

/**
 * Uses an imprecise rounding method to trim a number to the specified number
 * of decimal places; obtains merely "near enough" results.
 * @param  {Number} n
 * @param  {Number} [places=3]
 * @return {Number}
 * @private
 */
function truncateDecimals(n, places = 3) {
  return +(Math.round(`${n}e+${places}`)  + `e-${places}`);
};

/**
 * Calculates the amount of time, in milliseconds, since the specified call to
 * process.hrtime().
 * @param  {Array}  hrtime
 * @return {Number}
 * @private
 */
module.exports = function since(hrtime) {
  const end = process.hrtime(hrtime);

  return truncateDecimals(end[0] * 1000 + end[1] / 1000000);
};
