#!/usr/bin/env node

import { exec } from 'node:child_process'

const renderData = JSON.parse(process.env.OPERATOR_RENDER_DATA)
const operatorPath = renderData['server-info']['operator-path']
const subcommand = renderData['subcommand']

const escapeHtmlTextContent = (text) =>
  text.replace(/[<>&]/g, (character) => {
    switch (character) {
      case '<': return '&lt;'
      case '>': return '&gt;'
      case '&': return '&amp;'
    }
  })

const childProcess = exec(
  subcommand === undefined
    ? `"${operatorPath}" --help`
    : `"${operatorPath}" "${subcommand}" --help`,
)

process.stdout.write('<pre>')
for await (const helpChunk of childProcess.stdout) {
  process.stdout.write(escapeHtmlTextContent(helpChunk))
}
process.stdout.write('</pre>')
