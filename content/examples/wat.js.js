#!/usr/bin/env node
const me = require('fs').readFileSync(module.filename, 'utf8')
process.stdout.write(`document.addEventListener('DOMContentLoaded', _ => {
  document.body.style.whiteSpace = 'pre'
  document.body.style.fontFamily = 'monospace'
  document.body.textContent = ${JSON.stringify(me)}
})`)
