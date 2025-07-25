/**
 * Generate an HTML tree from hierarchial key/value pairs. Leaf values are JSON-encoded.
 */
export function* generateExpandableHtmlTree(data) {
  yield `<div class="expandable-tree data">`
  yield* generateTreeNode(data)
  yield `</div>`
}

function* generateTreeNode(data) {
  yield `<ul>`
  for (const [key, value] of Object.entries(data)) {
    yield '<li>'
    if (typeof value === 'object' && value !== null) {
      yield `<details>`
      yield `<summary>${key}</summary>`
      yield* generateTreeNode(value)
      yield `</details>`
    } else {
      yield `<strong>${key}:</strong> ${JSON.stringify(value)}`
    }
    yield '</li>'
  }
  yield `</ul>`
}
