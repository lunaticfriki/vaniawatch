export const SCOPES = [
  { value: 'core', name: 'core      domain package' },
  { value: 'backend', name: 'backend   Dart Frog server' },
  { value: 'frontend', name: 'frontend  Flutter app' },
  { value: 'repo', name: 'repo      docs, tooling, root config' },
]

export const TYPES = [
  { value: 'feat', name: 'feat      a new feature' },
  { value: 'fix', name: 'fix       a bug fix' },
  { value: 'test', name: 'test      adding or correcting tests' },
  { value: 'refactor', name: 'refactor  neither fixes a bug nor adds a feature' },
  { value: 'docs', name: 'docs      documentation only' },
  { value: 'style', name: 'style     formatting, no change in meaning' },
  { value: 'perf', name: 'perf      performance improvement' },
  { value: 'build', name: 'build     build system or dependencies' },
  { value: 'ci', name: 'ci        CI configuration' },
  { value: 'chore', name: 'chore     anything else' },
  { value: 'revert', name: 'revert    reverts a previous commit' },
]
