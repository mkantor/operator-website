#!/usr/bin/env node

import { generateExpandableHtmlTree } from '../.utilities/expandable-tree.mjs'

for (const html of generateExpandableHtmlTree(JSON.parse(process.env.OPERATOR_RENDER_DATA))) {
  process.stdout.write(html)
}
