const core = require('@actions/core');
const bent = require('bent');

async function run() {
    try {
        const get = bent('http://esotericsoftware.com/gloomhaven-helper');
        const stream = await get();
        const str = await stream.text()
        const found = str.match(/v([0-9]+)\.([0-9]+)\.?([0-9]*)/)

        console.log(`Regex matched: ${found}`);
        const version = found[0].substring(1);
        console.log(`Version: ${version} - Major: ${found[1]} - Minor: ${found[2]} - Patch: ${found[3]}`);
        core.setOutput('version', version);
        core.setOutput('major', found[1]);
        core.setOutput('minor', found[2]);
        core.setOutput('patch', found[3]);
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
