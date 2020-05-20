const fs = require('fs');

const input = fs.readFileSync('../input.txt', {encoding: 'utf8'})

const P_NUMBER = `(\\d+)`;
const P_IDENT = `(\\w+)`;
const P_CONST = `^${P_IDENT} -> ${P_IDENT}`;
const P_AND = `${P_IDENT} AND ${P_IDENT} -> ${P_IDENT}`
const P_OR = `${P_IDENT} OR ${P_IDENT} -> ${P_IDENT}`
const P_NOT = `NOT ${P_IDENT} -> ${P_IDENT}`
const P_LSHIFT = `${P_IDENT} LSHIFT ${P_NUMBER} -> ${P_IDENT}`
const P_RSHIFT = `${P_IDENT} RSHIFT ${P_NUMBER} -> ${P_IDENT}`

const to16Bit = (x) => x & 0xFFFF;

let numberRegex = new RegExp(P_NUMBER);
let isNumber = n => numberRegex.test(n);

let requires = (...variables) =>
    (state) =>
        variables.reduce(
            (acc, variable) => acc && (isNumber(variable) || state.hasOwnProperty(variable)),
            true
        );

// Either retrieve key from state or simply return numeric key
let get = (state, key) => isNumber(key) ? parseInt(key) : parseInt(state[key]);

const mapInputToExpressions = (input) =>
    input.trim().split('\n').reduce((expressions, instruction) => {
        let matches, val, a, b, c;

        let exp = {
            canBeEvaluated: (state) => false,
            evaluate: state => state,
            done: false,
        };

        if (null !== (matches = new RegExp(P_CONST).exec(instruction))) {
            [a, b] = matches.slice(1, 1 + 2);

            exp.canBeEvaluated = requires(a);
            exp.evaluate = state => {
                state[b] = get(state, a);
                return state;
            }

        } else if (null !== (matches = new RegExp(P_AND).exec(instruction))) {
            [a, b, c] = matches.slice(1, 1 + 3);

            exp.canBeEvaluated = requires(a, b);
            exp.evaluate = state => ({
                ...state, 
                [c]: get(state, a) & get(state, b)
            });
        } else if (null !== (matches = new RegExp(P_OR).exec(instruction))) {
            [a, b, c] = matches.slice(1, 1 + 3);

            exp.canBeEvaluated = requires(a, b);
            exp.evaluate = state => ({
                ...state,
                [c]: get(state, a) | get(state, b)
            });
        } else if (null !== (matches = new RegExp(P_NOT).exec(instruction))) {
            [a, b] = matches.slice(1, 1 + 2);

            exp.canBeEvaluated = requires(a);
            exp.evaluate = state => ({
                ...state,
                [b]: to16Bit(~get(state, a))
            });
        } else if (null !== (matches = new RegExp(P_LSHIFT).exec(instruction))) {
            [a, b, c] = matches.slice(1, 1 + 3);

            exp.canBeEvaluated = requires(a, b);
            exp.evaluate = state => ({
                ...state,
                [c]: to16Bit(get(state, a) << get(state, b))
            });
        } else if (null !== (matches = new RegExp(P_RSHIFT).exec(instruction))) {
            [a, b, c] = matches.slice(1, 1 + 3);

            exp.canBeEvaluated = requires(a);
            exp.evaluate = state => ({
                ...state,
                [c]: get(state, a) >> get(state, b)
            });
        }

        return [...expressions, exp];
    }, []);

let expressions = mapInputToExpressions(input);

let state = {};
let eval = (state) => {
    let i = 0;

    while (i < expressions.length) {
        let e = expressions[i];

        if (!e.done && e.canBeEvaluated(state)) {
            state = e.evaluate(state);
            e.done = true;
            i = 0;
        } else {
            i++;
        }
    }
    return state;
}

state = eval(state);

console.log('Part 1: ', state['a']);

const inputPart2 = input.replace('14146 -> b', `${state['a']} -> b`);

expressions = mapInputToExpressions(inputPart2);

state = eval({})

console.log('Part 2: ', state['a']);
