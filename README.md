# gmport

Port Game Maker games to iOS.

## Explanation

Game Maker games are inherently portable, as the Game Maker engine runs on many platforms. However, many games are only released for a subset of the supported platforms. This ports many Game Maker games to iOS. Games are controlled by a virtual gamepad that maps to digital keyboard input.

## Supported Games

 - [AM2R](http://metroid2remake.blogspot.com) (Another Metroid II Remake)
 - [Undertale](http://undertale.com)

Configuration for specific games is under `game`. Other games are likely to work; send pull requests with the configuration.

## Installation

### Prequisites

 - Recent macOS and Xcode.
 - [Ninja](https://ninja-build.org) to build:

        brew install ninja

 - [ios-deploy](https://github.com/phonegap/ios-deploy) to install:

        brew install node
        npm install -g ios-deploy

 - An unmodified, decrypted copy of a Game Maker game for iOS. I used [Crashlands](https://itunes.apple.com/us/app/crashlands/id808296431), which is free, but others should also work.
 - An original copy of the Game Maker game to port to iOS.
 - An iOS Developer program membership, to re-sign the app.

### Instructions

 1. Modify `input.ninja` as necessary; see contents for documentation.

 2. Build:

        ninja build

 3. Install onto attached device:

        ninja install

    Alternatively, package the app in `build` and install with iTunes or OTA.

## License

See the `LICENSE` file for details.

