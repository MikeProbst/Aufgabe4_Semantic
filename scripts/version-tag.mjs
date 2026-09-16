import { execFileSync } from 'node:child_process';

function git(...args) {
  return execFileSync('git', args, { encoding: 'utf8' }).trim();
}

function main() {
  const versionPattern = /^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/;

  const currentTags = git('tag', '--points-at', 'HEAD').split('\n');

  if (currentTags.some(tag => versionPattern.test(tag))) {
    console.log('Dieser Commit hat bereits einen Versions-Tag.');
    return;
  }

  const message = git('log', '-1', '--format=%B');
  const subject = message.split('\n')[0];
  const commit = /^([a-z]+)(?:\([^)]+\))?(!)?: .+/i.exec(subject);

  if (!commit) {
    console.log('Keine Conventional-Commit-Nachricht: kein neuer Tag.');
    return;
  }

  const type = commit[1].toLowerCase();
  const breakingChange =
    commit[2] === '!' ||
    /^BREAKING[ -]CHANGE: .+/m.test(message);

  if (!breakingChange && type !== 'feat' && type !== 'fix') {
    console.log('Dieser Commit benötigt keinen neuen Versions-Tag.');
    return;
  }

  const latestTag = git(
    'tag',
    '--merged',
    'HEAD',
    '--sort=-version:refname'
  )
    .split('\n')
    .find(tag => versionPattern.test(tag));

  // Ohne vorhandenen Versions-Tag mit 0.0.0 beginnen.
  let [major, minor, patch] = (latestTag ?? 'v0.0.0')
    .slice(1)
    .split('.')
    .map(BigInt);

  if (breakingChange) {
    major += 1n;
    minor = 0n;
    patch = 0n;
  } else if (type === 'feat') {
    minor += 1n;
    patch = 0n;
  } else {
    patch += 1n;
  }

  const nextTag = `v${major}.${minor}.${patch}`;

  git('tag', '-a', nextTag, '-m', `Release ${nextTag}`, 'HEAD');
  console.log(`Tag erstellt: ${nextTag}`);
}

try {
  main();
} catch (error) {
  console.error('Tag konnte nicht erstellt werden:', error.message);
  process.exitCode = 1;
}