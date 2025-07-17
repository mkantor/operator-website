#!/usr/bin/env node

// This is designed to flush output as it goes along, which usually improves perceived latency
// (although this executable is fast enough for it to not really matter).
function* generateTree(data) {
  yield `<ul>`
  for (const [key, value] of Object.entries(data)) {
    yield '<li>'
    if (typeof value === 'object' && value !== null) {
      yield `<details>`
      yield `<summary>${key}</summary>`
      yield* generateTree(value)
      yield `</details>`
    } else {
      yield `<strong>${key}:</strong> ${JSON.stringify(value)}`
    }
    yield '</li>'
  }
  yield `</ul>`
}

// This CSS is inline because it's tightly coupled to the HTML structure. In the future it could be
// generalized and moved to a stylesheet.
const css = `
.expandable-tree {
  --marker-width: 0.7rem;
}
.expandable-tree ul {
  margin-left: var(--marker-width);
  list-style-type: none;
  padding-left: 0;
  margin-top: 0;
  margin-bottom: 0;
}
.expandable-tree > ul {
  margin-left: 0;
}
.expandable-tree details {
  margin: 0;
}
.expandable-tree summary {
  font-weight: bold;
  list-style-type: none;
  padding-left: 0;
}
  .expandable-tree summary::before {
    display: inline-block;
    width: var(--marker-width);
    font-size: 0.8em;
    vertical-align: 10%;
  }
    .expandable-tree details[open] summary::before {
      content: "▼";
    }
    .expandable-tree details:not([open]) summary::before {
      content: "▶";
    }
`

process.stdout.write(`<style>${css}</style>`)
process.stdout.write(`<div class="expandable-tree data">`)
for (const html of generateTree(JSON.parse(process.env.OPERATOR_RENDER_DATA))) {
  process.stdout.write(html)
}
process.stdout.write(`</div>`)
