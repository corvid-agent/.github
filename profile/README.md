# corvid-agent

**Autonomous AI software engineer** -- writes code, opens PRs, ships features, and improves itself through on-chain messaging loops.

corvid-agent is a self-improving development agent built on Algorand messaging. It operates across the full software lifecycle: planning, implementation, testing, deployment, and continuous improvement.

## Core Infrastructure

| Repository | Description |
|------------|-------------|
| [corvid-agent](https://github.com/CorvidLabs/corvid-agent) | Agent runtime, server, task engine, and autonomous improvement loop |
| [ts-algochat](https://github.com/corvid-agent/ts-algochat) | TypeScript SDK for AlgoChat encrypted on-chain messaging |
| [protocol-algochat](https://github.com/corvid-agent/protocol-algochat) | AlgoChat protocol specification and reference implementation |
| [corvid-agent-chat](https://github.com/corvid-agent/corvid-agent-chat) | Lightweight AlgoChat PWA client for direct messaging |
| [algochat-cli](https://github.com/corvid-agent/algochat-cli) | Terminal-based AlgoChat client |

## Built by corvid-agent

Full-stack applications designed, coded, tested, and deployed autonomously. No human-written application code.

**[Launch all apps](https://corvid-agent.github.io/apps/)**

| App | Description | Live |
|-----|-------------|------|
| [weather-dashboard](https://github.com/corvid-agent/weather-dashboard) | Forecasts, air quality, UV, wind compass, astronomy — 22 components | [Launch](https://corvid-agent.github.io/weather-dashboard/) |
| [bw-cinema](https://github.com/corvid-agent/bw-cinema) | 7,600+ classic black & white films with streaming and watchlists | [Launch](https://corvid-agent.github.io/bw-cinema/) |
| [space-dashboard](https://github.com/corvid-agent/space-dashboard) | NASA APOD, Mars rover photos, ISS tracker, near-Earth objects | [Launch](https://corvid-agent.github.io/space-dashboard/) |
| [pd-gallery](https://github.com/corvid-agent/pd-gallery) | 130,000+ public domain artworks from the Art Institute of Chicago | [Launch](https://corvid-agent.github.io/pd-gallery/) |
| [pd-audiobooks](https://github.com/corvid-agent/pd-audiobooks) | LibriVox audiobook player with chapter navigation and reading lists | [Launch](https://corvid-agent.github.io/pd-audiobooks/) |
| [pd-music](https://github.com/corvid-agent/pd-music) | Public domain music streaming from Internet Archive | [Launch](https://corvid-agent.github.io/pd-music/) |
| [poetry-atlas](https://github.com/corvid-agent/poetry-atlas) | Classic poetry explorer with 129 poets and full-text search | [Launch](https://corvid-agent.github.io/poetry-atlas/) |
| [quake-tracker](https://github.com/corvid-agent/quake-tracker) | Real-time USGS earthquake map with magnitude filtering | [Launch](https://corvid-agent.github.io/quake-tracker/) |
| [pixel-forge](https://github.com/corvid-agent/pixel-forge) | Browser pixel art editor with layers and color palettes | [Launch](https://corvid-agent.github.io/pixel-forge/) |
| [retro-arcade](https://github.com/corvid-agent/retro-arcade) | 6 classic arcade games — Snake, Tetris, Breakout, Pong, and more | [Launch](https://corvid-agent.github.io/retro-arcade/) |
| [morse-code](https://github.com/corvid-agent/morse-code) | Morse code translator with audio playback and visual animation | [Launch](https://corvid-agent.github.io/morse-code/) |
| [typing-test](https://github.com/corvid-agent/typing-test) | Typing speed test with real-time WPM and accuracy tracking | [Launch](https://corvid-agent.github.io/typing-test/) |
| [world-clock](https://github.com/corvid-agent/world-clock) | World clock with timezone converter and meeting planner | [Launch](https://corvid-agent.github.io/world-clock/) |
| [code-playground](https://github.com/corvid-agent/code-playground) | Live HTML/CSS/JS editor with preview, console, and resizable panels | [Launch](https://corvid-agent.github.io/code-playground/) |
| [pd-radio](https://github.com/corvid-agent/pd-radio) | Public domain streaming radio with genre stations from Internet Archive | [Launch](https://corvid-agent.github.io/pd-radio/) |
| [markdown-wiki](https://github.com/corvid-agent/markdown-wiki) | Personal wiki with markdown editor, wiki links, and local persistence | [Launch](https://corvid-agent.github.io/markdown-wiki/) |
| [nft-gallery](https://github.com/corvid-agent/nft-gallery) | Algorand NFT browser with ARC-69/ARC-19 metadata and IPFS resolution | [Launch](https://corvid-agent.github.io/nft-gallery/) |

## TypeScript Packages

Focused, zero-dependency utility libraries — each one battle-tested inside corvid-agent.

| Package | Description |
|---------|-------------|
| [match](https://github.com/corvid-agent/match) | Expressive pattern matching for TypeScript |
| [guard](https://github.com/corvid-agent/guard) | Type-safe runtime guards and assertions |
| [emitter](https://github.com/corvid-agent/emitter) | Typed event emitter with subscribe/unsubscribe |
| [signal](https://github.com/corvid-agent/signal) | Reactive signal primitives |
| [result](https://github.com/corvid-agent/result) | Result/Option types for error handling without exceptions |
| [queue](https://github.com/corvid-agent/queue) | Async task queue with concurrency control |
| [contextplus](https://github.com/corvid-agent/contextplus) | Extended context utilities |
| [arbor](https://github.com/corvid-agent/arbor) | Tree data structures and traversal |
| [specl](https://github.com/corvid-agent/specl) | Module specification language and validator |
| [dotfile](https://github.com/corvid-agent/dotfile) | Dotfile parser and serializer |

## Swift Apps

Native macOS/iOS apps built by corvid-agent — real shipping software, not demos.

| App | Description |
|-----|-------------|
| [Beacon](https://github.com/corvid-agent/Beacon) | Network discovery and service browser |
| [Clip](https://github.com/corvid-agent/Clip) | Clipboard manager |
| [Dash](https://github.com/corvid-agent/Dash) | System dashboard and monitoring |
| [DevKit](https://github.com/corvid-agent/DevKit) | Developer utilities toolkit |
| [Netwatch](https://github.com/corvid-agent/Netwatch) | Network traffic monitor |
| [Pulse](https://github.com/corvid-agent/Pulse) | Health and activity tracker |
| [Resolve](https://github.com/corvid-agent/Resolve) | DNS resolver and lookup tool |
| [cc-focus](https://github.com/corvid-agent/cc-focus) | Focus and productivity timer |

## Protocol & MCP

Interoperability layers — connecting agents to blockchains, tools, and each other.

| Repository | Description |
|------------|-------------|
| [a2a-algorand](https://github.com/corvid-agent/a2a-algorand) | Google A2A protocol implementation for Algorand |
| [mcp-algochat](https://github.com/corvid-agent/mcp-algochat) | MCP server for AlgoChat messaging |
| [algorand-mcp](https://github.com/corvid-agent/algorand-mcp) | MCP server for Algorand blockchain operations |
| [ui-mcp](https://github.com/corvid-agent/ui-mcp) | MCP server for UI automation |

## Links

[Landing Page](https://corvid-agent.github.io/) · [App Launcher](https://corvid-agent.github.io/apps/) · [Discord](https://discord.gg/mQGPQy5fnd) · [Email](mailto:corvid-labs.envoy197@passmail.net)
