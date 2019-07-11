![IPA Uploader](https://github.com/rwbutler/IPAUploader/raw/master/docs/images/ipa-uploader-banner.png)

[![CI Status](http://img.shields.io/travis/rwbutler/IPAUploader.svg?style=flat)](https://travis-ci.org/rwbutler/IPAUploader)
[![Maintainability](https://api.codeclimate.com/v1/badges/68758295a60203d6a031/maintainability)](https://codeclimate.com/github/rwbutler/IPAUploader/maintainability)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](https://github.com/rwbutler/IPAUploader/blob/master/LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://swift.org/)

Uploads your apps to TestFlight & App Store.

## Features

- [x] Uploads IPAs to TestFlight and the App Store.
- [x] Designed to be invoked from an automation server e.g. Jenkins as part of your CI process.
- [x] Optionally provides the option to notify of upload status via [Slack](https://slack.com/).

For more information on IPA Uploader, take a look at the [keynote presentation](https://github.com/rwbutler/IPAUploader/blob/master/docs/presentations/ipa-uploader.pdf).

# Installation

## Homebrew

To install using [Homebrew](https://brew.sh/):

```bash
brew install rwbutler/tools/ipa-uploader
```

# Usage

The IPA Uploader tool is invoked as follows:

* `--ipa-path`: The path to the IPA to be uploaded.
* `--itms-transporter-path`: [Optional] The path to ITMSTransporter for uploading.
* `--username`: The username of the Apple ID to upload the IPA as.
* `--password`: The app-specific password to use when uploading the IPA (see below).
* `--slack-url`: [Optional] The hook URL for posting to Slack.
* `--timeout`: [Optional] A timeout specified in seconds to wait on the upload.

## App-Specific Passwords

An app-specific password is one which is generated and then provided to a third-party app to allow limited access to perform authorized actions using your Apple ID. This prevents your account credentials from being compromised.

In order to generate an app-specific password login at [https://appleid.apple.com](https://appleid.apple.com) and then scroll down to the __Security__ section. Under __App-Specific Passwords__, follow the __Generate Password...__ link.

## Author

[Ross Butler](https://github.com/rwbutler)

## License

IPA Uploader is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.

## Additional Software

### Controls

* [AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) - Powerful gradient animations made simple for iOS.

|[AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) |
|:-------------------------:|
|[![AnimatedGradientView](https://raw.githubusercontent.com/rwbutler/AnimatedGradientView/master/docs/images/animated-gradient-view-logo.png)](https://github.com/rwbutler/AnimatedGradientView) 

### Frameworks

* [Cheats](https://github.com/rwbutler/Cheats) - Retro cheat codes for modern iOS apps.
* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [Hash](https://github.com/rwbutler/Hash) - Lightweight means of generating message digests and HMACs using popular hash functions including MD5, SHA-1, SHA-256.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)