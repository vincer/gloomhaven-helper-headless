const core = require('@actions/core');
const bent = require('bent');

async function run() {
    try {
        const get = bent('http://esotericsoftware.com/gloomhaven-helper');
        const stream = await get();
        const str = await stream.text()
        const found = str.match(/v[0-9.]+/)

        console.log(`Regex matched: ${found}`);
        const version = found[0].substr(1);
        console.log(`Version: ${version}`);
        core.setOutput('version', version);
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
