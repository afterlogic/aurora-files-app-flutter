# Getting started


## Installing the required tools

1. Clone the [repository](https://github.com/afterlogic/aurora-files-app-flutter)
   
   1.1. For development on MacOS please install [Xcode](https://apps.apple.com/app/xcode/id497799835?l=en&mt=12)
   
   1.2. For development on Windows or Linux please install [Android Studio](https://developer.android.com/studio)
   
   1.3. Install Flutter according to [instructions](https://flutter.dev/docs/get-started/install) (Flutter v2.2.3)
   
   1.4. Install Java JDK. Since Aurora Files uses gradle build tool, it has impact on the version of Java to be installed. You can check related requirements at https://gradle.org/install/. At the time of writing it's Java 8
   
   1.5. If PGP functionality is required, the "Java to Objective-C Translator" needs to be installed as well.
   Download [j2objc](https://github.com/google/j2objc/releases/download/2.7/j2objc-2.7.zip), unpack into `ios` directory and rename the unpacked directory to `dist`.

## Preparing a build config
2. The starting point for building any version, including regular one, is a set of configuration files and images. A template for creating your own configuration can be found in `build_res` directory. Set of resources for building regular version can be found there as well. To switch to custom build, run `sh/build_variant.sh <path>` where `path` variable holds a path to `build_variant.yaml` file in a directory holding custom version resources. For example: `sh/build_variant.sh build_res/afterlogic/build_variant.yaml`
   
   2.1. Before building a regular version you need to correct the `build_res/afterlogic/build_variant.yaml` file according to paragraphs 3.3 and 5.2 of this manual.

## Creating a custom build config
3. You may want to make a custom build of the app with own styles. To do this please follow the steps below:
   - copy `template` directory from `build_res` and rename it with an arbitrary name - it holds all the resources required by an application
   - in the `build_variant.yaml` file of your configuration, specify the parameter values (see paragraphs 3.1, 5.2)
   - change theme and update image files (see paragraph 3.2)
   - setup Firebase project (see paragraph 3.3)
   - specify the signature key for Android (see paragraph 5.2)   

   3.1. In the application, you can turn specific features on/off by specifying `true` or `false` in `build_variant.yaml` file of your configuration.
   Build flags:
   - pgpEnable - Enable the PGP File Encryption
   - legacyPgpKey - Using the outdated file encryption model
   - secureSharingEnable - Enables the Public Links feature
   - teamSharingEnable - Using file sharing for the team
   - useMainLogo - Using `main_logo.png` on login screen
   - useYubiKit / yubico_flutter_lib - Allows to use Secure Hardware Keys for 2FA on iOS
   - logger - Enables internal logging within the app
   - supportAllowAccess - Internal setting used for determining whether app access can be restricted
   
   3.2. Changing theme and updating image files.
   The color scheme is described in `theme/lib/app_color.dart` file.
   Images are found in `image` subdirectory. All the images must be of 512 x 512 or 1024 x 1024 size:
   - `icon.png` icon is used on desktop. Should not have alpha channel.
   - `icon_foreground.png` icon with transparent background is used as physical icon in some versions of Android.
   - `main_logo.png` icon is displayed on the Login and About screens.
   
   3.3. Configuring Firebase project.
   The project uses Firebase service for collecting analytics data. To build the app, you need to create Firebase project. It can be done [here](https://firebase.google.com/).In the project, create 2 apps, for iOS and Android versions.
   In the directory with app template, create `crashlytics` directory and place two files in it: `GoogleService-Info.plist` and `google-services.json` from respective apps in Firebase project.
   
   The files can be found in Firebase console as follows:
   Firebase > YOUR_PROJECT > Project settings > SDK setup and configuration 
   File `GoogleService-Info.plist` is available for iOS apps.
   File `google-services.json` is available for Androind

## Building the app for iOS
4. To build iOS app:

   4.1. In your Apple account, create id for AppGroup, with `App Groups` type selected when creating ID.
   It can be done [here](https://developer.apple.com/account/resources/identifiers/list)

   Also, you need to create app id and id for AppShareExtension module which is constructed as your app id + ".AppShareExtension".
   For example, id = `my.app.id` id AppShareExtension = `my.app.id.AppShareExtension`

   And activate `App Groups` for both ids, using the group created earlier

   Then specify app id and group id in corresponding fields of `build_variant.yaml` file. There's no need to specify id AppShareExtension.
   Make sure to specify Team ID. You can find it [here](https://developer.apple.com/account/#/membership)

   4.2. To create certificates for signing iOS version, open XCode project. Click root project Runner in project structure, and in the new window opened, select Runner from Targets list, then select Signing & Capabilities. Certificates should be created automatically.

   4.3. To build iOS version run `sh/build_ios.sh`
   Package built will be placed to `build` directory, it can be uploaded to TestFlight using [Transporter](https://apps.apple.com/app/transporter/id1450874784?l=en&mt=12) application.


## Building the app for Android
5. To build Android app:

   5.1. Specify `_appId`, for example `my.app.id` in `build_variant.yaml` file.

   5.2. To sign the application, creating [signing key](https://developer.android.com/studio/publish/app-signing#generate-key) is required.
   The file `key.jks`, which contains app signing key, needs to be placed to `build_res/sign` directory.
   Edit the `key_template.properties` file and rename it into `key.properties`.

   5.3. To build Android version run `sh/build_android.sh`
   Packages built will be placed to `build` directory.
