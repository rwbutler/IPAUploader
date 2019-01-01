![IPA Uploader](https://github.com/rwbutler/IPAUploader/raw/master/docs/images/ipa-uploader-banner.png)

[![CI Status](http://img.shields.io/travis/rwbutler/IPAUploader.svg?style=flat)](https://travis-ci.org/rwbutler/IPAUploader)
[![Maintainability](https://api.codeclimate.com/v1/badges/68758295a60203d6a031/maintainability)](https://codeclimate.com/github/rwbutler/IPAUploader/maintainability)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](https://github.com/rwbutler/IPAUploader/blob/master/LICENSE)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://swift.org/)

Uploads your apps to TestFlight & App Store.

For more information on IPA Uploader, take a look at the [keynote presentation](https://github.com/rwbutler/IPAUploader/blob/master/docs/presentations/ipa-uploader.pdf).

# Installation

## Homebrew

To install using [Homebrew](https://brew.sh/):

```bash
brew tap rwbutler/tools
brew install ipa-uploader
```

# Usage

The IPA Uploader tool is invoked as follows:

* `--ipa-path`: The path to the IPA to be uploaded.
* `--itms-transporter-path`: [Optional] The path to ITMSTransporter for uploading.
* `--username`: The username of the Apple ID to upload the IPA as.
* `--password`: The password of the Apple ID to upload the IPA as.
* `--slack-url`: [Optional] The hook URL for posting to Slack.
* `--timeout`: [Optional] A timeout specified in seconds to wait on the upload.

## Additional Software

### Frameworks

* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://github.com/rwbutler/TypographyKit/raw/master/TypographyKitLogo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)