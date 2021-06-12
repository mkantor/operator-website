#!/usr/bin/env node
const thisFile = require('fs').readFileSync(module.filename, 'utf8')
console.log(`alert("me IRL:\\n\\n" + ${JSON.stringify(thisFile)})`)
