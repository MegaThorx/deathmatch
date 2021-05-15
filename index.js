console.log('BIG OOF')

const core = require('@actions/core');
const github = require('@actions/github');
const fs = require('fs');
const path = require('path');

try {
    const folder = core.getInput('folder');
    const secret = core.getInput('secret');

    const payload = JSON.stringify(github.context.payload, undefined, 2)
    console.log(`The event payload: ${payload}`);

    console.log(__dirname);
} catch (error) {
    core.setFailed(error.message);
}