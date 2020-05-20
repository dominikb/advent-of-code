const fs = require('fs');

let input = fs.readFileSync('../input.txt', {encoding: 'UTF-8'});

const codeLetters = input.replace('\s+', '').length;

let withoutEscaping = input
    .replace('\s+', '')
    .replace(/\\\\/g, '1')
    .replace(/\\"/g, '1')
    .replace(/"/g, '')
    .replace(/\\x[a-f0-9]{2}/g, '1')

let textLetters = withoutEscaping.length;

console.log('Part 1: ', codeLetters, ' - ', textLetters, ' = ', codeLetters-textLetters);

let encoded = input
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/^(.*)$/gm, m => `"${m}"`)

console.debug(`Part2: `, encoded.length, ' - ', input.length, ' = ' , encoded.length - input.length);