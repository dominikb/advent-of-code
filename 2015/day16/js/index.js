const fs = require('fs');
const path = require('path');

let input = fs.readFileSync(
    path.join(__dirname, '..', 'input.txt'),
    {encoding: 'UTF8'}
);

let aunts = input.trim().split('\n')
    .map(line => line.split(' '))
    .map(words => words.map(w => w.match(/\w+/)))
    .map(props => ({
        index: props[1][0],
        [props[2][0]]: parseInt(props[3][0]),
        [props[4][0]]: parseInt(props[5][0]),
        [props[6][0]]: parseInt(props[7][0]),
    }))

let known = {
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1,
}

let [match] = aunts.filter(aunt => {
    for (const [key, value] of Object.entries(known)) {
        if (aunt.hasOwnProperty(key) && aunt[key] !== value)
            return false;
    }
    return true;
})

console.debug("Part1: " + match.index);


let [match2] = aunts.filter(aunt => {
    for (const [key, value] of Object.entries(known)) {
        let compare = (a, b) => a !== b;

        if (['cats', 'trees'].includes(key))
            compare = (a, b) => a <= b;

        if (['pomeriansias', 'goldfish'].includes(key))
            compare = (a, b) => a >= b;

        if (aunt.hasOwnProperty(key) && compare(aunt[key], value))
            return false;
    }
    return true;
})

console.log(`Part2: ${match2.index}`);
