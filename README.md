## Important

I (@jfcherng) no longer maintain this repository because [@github/copilot-language-server][] is a drop-in replacement for it and maintained by Microsoft. If you are willing to maintain this repository and the [corresponding NPM package][copilot-node-server-npm], just contact me.

## Introduce

Copilot Node.js server stripped from [copilot.vim] and published on [NPM][copilot-node-server-npm].

## Usage

To start the server, execute either of the following

- `npx copilot-node-server --stdio`

  This one is recommended if `npx` is available.

- `node copilot/dist/language-server.js --stdio`

  This one is not recommended because the script path may vary among (upstream) releases.
  E.g., the upstream renamed `agent.js` to `language-server.js` in the `1.34.0` release.

## Reporting issues

This repository doesn't modify any upstream file.
If you have any Copilot issue or any server issue, please submit it to [Copilot discussions][copilot-discussions].

[@github/copilot-language-server]: https://www.npmjs.com/package/@github/copilot-language-server
[copilot-discussions]: https://github.com/orgs/community/discussions/categories/copilot
[copilot-node-server-npm]: https://www.npmjs.com/package/copilot-node-server
[copilot.vim]: https://github.com/github/copilot.vim
