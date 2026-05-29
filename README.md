# NetworkMonitor

NetworkMonitor is a lightweight macOS menu bar app for keeping an eye on live network throughput without opening Activity Monitor. It shows current download and upload rates directly in the menu bar, with quick access to disk space and sampling status from the menu.

## Features

- Live download and upload rates in the macOS menu bar
- One-click menu with current network rates, free disk space, total disk size, and last update time
- Automatic refresh every second
- Manual refresh and quit actions from the menu
- Native SwiftUI menu bar app with no background service dependency

## Download

The first release is packaged as a DMG for GitHub Releases:

- `dist/NetworkMonitor-1.0.0.dmg` for Apple Silicon Macs

After downloading, open the DMG and drag `NetworkMonitor.app` to your Applications folder.

This first build is not notarized. If macOS blocks the app, open it from Finder using Control-click, choose Open, then confirm that you want to run it.

## Requirements

- macOS 13 Ventura or newer
- Apple Silicon Mac for the packaged v1.0.0 DMG
- Swift 6.0 or newer for local development builds

## Development

This project is a Swift Package Manager app.

Run the app locally:

```bash
./script/build_and_run.sh
```

Build a release app bundle:

```bash
./script/build_and_run.sh --release
```

Build the release DMG:

```bash
./script/build_and_run.sh --dmg
```

Run tests:

```bash
swift test
```

## Project Structure

- `Sources/NetworkMonitor`: macOS app entry point and menu bar UI
- `Sources/NetworkMonitorCore`: sampling, network counters, disk space, and formatting logic
- `Tests/NetworkMonitorCoreTests`: unit tests for core behavior
- `script/build_and_run.sh`: local build, run, verification, and DMG packaging helper

## GitHub About

Lightweight macOS menu bar app that shows live upload/download speed and basic system status.
