import { SCOPES, TYPES } from './scripts/git/commit-conventions.mjs'

export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', TYPES.map(({ value }) => value)],
    'scope-enum': [2, 'always', SCOPES.map(({ value }) => value)],
    'scope-empty': [2, 'never'],
  },
}
