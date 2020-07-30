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
        const semver = version.match(/^([0-9]+)\.([0-9]+)\.?([0-9]*)/)
        console.log(semver);
        console.log(`Version: ${version} - Major: ${semver[1]} - Minor: ${semver[2]} - Patch: ${semver[3]}`);
        core.setOutput('version', version);
        core.setOutput('major', semver[1]);
        core.setOutput('minor', semver[2]);
        core.setOutput('patch', semver[3]);
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
