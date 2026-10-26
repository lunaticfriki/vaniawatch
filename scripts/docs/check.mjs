import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs'
import { basename, join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'

const ROOT = fileURLToPath(new URL('../..', import.meta.url))
const VAULT = join(ROOT, 'docs')
const IGNORED_VAULT_DIRS = new Set(['.obsidian', '_templates'])
const DOCUMENTED_CODE_DIRS = [
  { dir: 'core/lib/src', exclude: ['core/lib/src/testing/'] },
  { dir: 'frontend/lib/modules', exclude: [] },
  { dir: 'frontend/lib/shared', exclude: [] },
  { dir: 'backend/lib/modules', exclude: [] },
  { dir: 'backend/lib/shared', exclude: [] },
  { dir: 'backend/routes', exclude: [] },
]

const walk = (dir, accept, skipDir = () => false) =>
  existsSync(dir)
    ? readdirSync(dir).flatMap((name) => {
        const path = join(dir, name)
        if (statSync(path).isDirectory()) return skipDir(name) ? [] : walk(path, accept, skipDir)
        return accept(path) ? [path] : []
      })
    : []

const normalizeHeading = (text) => text.replace(/[`*_]/g, '').trim().toLowerCase()

const stripCode = (markdown) =>
  markdown.replace(/^```[\s\S]*?^```/gm, '').replace(/`[^`\n]*`/g, '')

const parseFrontmatter = (markdown) => {
  const match = markdown.match(/^---\n([\s\S]*?)\n---/)
  if (!match) return {}
  const data = {}
  let listKey = null
  for (const line of match[1].split('\n')) {
    const item = line.match(/^\s+-\s+(.*)$/)
    if (item && listKey) {
      data[listKey].push(item[1].trim())
      continue
    }
    const pair = line.match(/^([\w-]+):\s*(.*)$/)
    if (!pair) continue
    const [, key, value] = pair
    if (value === '' || value === '[]') {
      data[key] = []
      listKey = key
    } else {
      data[key] = value.trim()
      listKey = null
    }
  }
  return data
}

const notes = walk(VAULT, (path) => path.endsWith('.md'), (name) => IGNORED_VAULT_DIRS.has(name)).map(
  (path) => {
    const content = readFileSync(path, 'utf8')
    return {
      path,
      name: basename(path, '.md'),
      vaultPath: relative(VAULT, path).replace(/\.md$/, ''),
      content,
      frontmatter: parseFrontmatter(content),
      headings: content
        .split('\n')
        .filter((line) => /^#{1,6} /.test(line))
        .map((line) => normalizeHeading(line.replace(/^#+ /, ''))),
    }
  },
)

const notesByName = new Map()
for (const note of notes) {
  notesByName.set(note.name, note)
  notesByName.set(note.vaultPath, note)
}

const errors = []

const checkCaseCollisions = () => {
  const byLowerName = new Map()
  for (const note of notes) {
    const key = note.name.toLowerCase()
    const existing = byLowerName.get(key)
    if (existing && existing.name !== note.name) {
      errors.push(`${note.vaultPath}: name differs only by case from ${existing.vaultPath}`)
    }
    byLowerName.set(key, note)
  }
}

const checkLinks = (note) => {
  for (const [, target, heading] of stripCode(note.content).matchAll(
    /!?\[\[([^\]|#]*)(?:#([^\]|]*))?(?:\|[^\]]*)?\]\]/g,
  )) {
    const linked = target === '' ? note : notesByName.get(target.trim())
    if (!linked) {
      if (!existsSync(join(VAULT, target))) errors.push(`${note.vaultPath}: broken link [[${target}]]`)
      continue
    }
    if (heading && !linked.headings.includes(normalizeHeading(heading))) {
      errors.push(`${note.vaultPath}: missing heading [[${target}#${heading}]]`)
    }
  }
}

const listOf = (value) => (Array.isArray(value) ? value : [])

const checkSources = (note) => {
  if (note.frontmatter.status !== 'implemented') return
  for (const key of ['source', 'tests']) {
    for (const path of listOf(note.frontmatter[key])) {
      if (!existsSync(join(ROOT, path))) errors.push(`${note.vaultPath}: ${key} not found ${path}`)
    }
  }
}

const checkCoverage = () => {
  const documented = new Set(notes.flatMap((note) => listOf(note.frontmatter.source)))
  for (const { dir, exclude } of DOCUMENTED_CODE_DIRS) {
    for (const file of walk(join(ROOT, dir), (path) => path.endsWith('.dart'))) {
      const path = relative(ROOT, file)
      if (exclude.some((prefix) => path.startsWith(prefix))) continue
      if (!documented.has(path)) errors.push(`undocumented code: ${path} is not in any note's source`)
    }
  }
}

for (const note of notes) {
  checkLinks(note)
  checkSources(note)
}
checkCaseCollisions()
checkCoverage()

if (errors.length > 0) {
  console.error(`✗ docs: ${errors.length} problem(s)`)
  for (const error of errors) console.error(`  ${error}`)
  console.error('  See docs/development/05-docs-vault.md')
  process.exit(1)
}

console.log(`✓ docs: ${notes.length} notes, links, sources and coverage OK`)
