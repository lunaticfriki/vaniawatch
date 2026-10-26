import { execSync } from 'node:child_process'
import { writeFileSync } from 'node:fs'
import { input, select } from '@inquirer/prompts'
import { SCOPES, TYPES } from './commit-conventions.mjs'

const SKIPPED_SOURCES = new Set(['message', 'merge', 'squash', 'commit'])

const [, , messageFile, source] = process.argv

const shouldPrompt = () =>
  Boolean(messageFile) && !SKIPPED_SOURCES.has(source) && process.stdin.isTTY

const stagedScopes = () => {
  const files = execSync('git diff --cached --name-only', { encoding: 'utf8' })
    .split('\n')
    .filter(Boolean)
  const scopeOf = (file) =>
    SCOPES.find(({ value }) => file.startsWith(`${value}/`))?.value ?? 'repo'
  return [...new Set(files.map(scopeOf))]
}

const ask = async () => {
  const staged = stagedScopes()
  const scope = await select({
    message: 'Folder',
    choices: SCOPES,
    default: staged.length === 1 ? staged[0] : undefined,
  })
  const type = await select({ message: 'Type of change', choices: TYPES })
  const description = await input({
    message: 'Commit message',
    required: true,
    validate: (value) => value.trim().length > 0 || 'The message cannot be empty',
  })
  return `${type}(${scope}): ${description.trim()}`
}

if (shouldPrompt()) {
  try {
    writeFileSync(messageFile, `${await ask()}\n`)
  } catch {
    console.error('Commit aborted.')
    process.exit(1)
  }
}
