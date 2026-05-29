# NetworkMonitor

NetworkMonitor is a lightweight macOS menu bar app for keeping an eye on live network throughput without opening Activity Monitor. It shows current download and upload rates directly in the menu bar, with quick access to disk space and sampling status from the menu.

## Features

- Live download and upload rates in the macOS menu bar
- One-click menu with current network rates, free disk space, total disk size, and last update time
- Automatic refresh every second
- Manual refresh and quit actions from the menu
- Native SwiftUI menu bar app with no background service dependency

## Requirements

- macOS 13 Ventura or newer
- Xcode Command Line Tools or Xcode with Swift 6.0 or newer

## Build From Source

This project is a Swift Package Manager app.

Clone the repository and enter the project directory:

```bash
git clone https://github.com/404priyanshu/NetworkMonitor-Swift.git
cd NetworkMonitor-Swift
```

Build and launch the menu bar app locally:

```bash
./script/build_and_run.sh
```

The helper script builds the Swift package, creates `dist/NetworkMonitor.app`, applies local ad-hoc signing, and opens the app.

Build a release app bundle without launching it:

```bash
./script/build_and_run.sh --release
```

The release bundle is written to:

```text
dist/NetworkMonitor.app
```

You can move that local app bundle into your Applications folder if you want to keep it installed on your Mac.

## Development

Run the app locally:

```bash
./script/build_and_run.sh
```

Build a release app bundle:

```bash
./script/build_and_run.sh --release
```

Run tests:

```bash
swift test
```

## Project Structure

- `Sources/NetworkMonitor`: macOS app entry point and menu bar UI
- `Sources/NetworkMonitorCore`: sampling, network counters, disk space, and formatting logic
- `Tests/NetworkMonitorCoreTests`: unit tests for core behavior
- `script/build_and_run.sh`: local build, run, verification, and app bundle helper

## GitHub About

Lightweight macOS menu bar app that shows live upload/download speed and basic system status.
