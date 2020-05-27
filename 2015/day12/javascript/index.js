let input = require('../input.json');

let r = new RegExp(/(-?\d+)/g);
const sum = [...JSON.stringify(input).matchAll(r)]
    .map(x => x[0])
    .reduce((sum, x) => sum + parseInt(x), 0);

console.log(`Part1: ${sum}`);

const sumReduce = (sum, x) => sum + x;
    
let recurse = (obj) => {
    if (typeof obj === 'number') {
        return obj
    }

    if (obj == parseInt(obj)) {
        return parseInt(obj);
    }
    
    if (Array.isArray(obj)) {
        return obj.map(recurse)
            .reduce(sumReduce, 0);
    }
    
    if (typeof obj === 'object' && ! Object.values(obj).includes('red')) {
        return Object.values(obj)
            .concat(Object.keys(obj))
            .map(recurse)
            .reduce(sumReduce, 0);
    }
    
    return 0;
};

console.log(`Part2: ${recurse(input)}`);
