1. Clone the [repository](https://github.com/afterlogic/aurora-files-app-flutter)
2. Install [Xcode](https://apps.apple.com/app/xcode/id497799835?l=en&mt=12)
3. Install [Android Studio](https://developer.android.com/studio)
4. Install Flutter according to [instructions](https://flutter.dev/docs/get-started/install)

5. If PGP functionality is required, the following tools need to be installed Java to Objective-C Translator.
   Download [j2objc](https://github.com/google/j2objc/releases/download/2.7/j2objc-2.7.zip), unpack into `ios` directory and rename the unpacked directory to `dist`.

6. The starting point for building any version, including custom one, is a set of configuration files and images.
   Set of resources for building regular version is found in `build_res` directory, it also contains a template for creating a custom build.
   To switch to custom build, run `sh/build_variant.sh <path>` where `path` variable holds a path to `build_variant.yaml` file in a directory holding custom version resources.
   For example, `sh/build_variant.sh build_res/afterlogic/build_variant.yaml`

7. To create a custom build:
- copy `template` directory from `build_res` and rename it with an arbitrary name - it holds all the resources required by an application
- in the `build_variant.yaml` file of your configuration, specify the parameter values (see paragraphs 7.1, 8.1, 9.1)
- change theme and update image files (see paragraph 7.2)
- setup Firebase project (see paragraph 7.3)
- specify the signature key for Android (see paragraph 9.2)

7.1. In the application, you can turn specific features on/off by specifying `true` or `false` in for a flag in `build_variant.yaml` file of your configuration.
Build flags:
* legacyPgpKey - using the old version of the keys
* logger - debug logging of the application
* pgpEnable - using Pgp keys
* secureSharingEnable - using password-protected links
* supportAllowAccess - using the server property "AllowAccess"
* teamSharingEnable - using file sharing for the team
* useMainLogo - using `main_logo.png` on login screen
* useYubiKit / yubico_flutter_lib - using YubiKit for two-factor authorization

7.2. Changing theme and updating image files.
The color scheme is described in `theme/lib/app_color.dart` file.
Images are found in `image` subdirectory. All the images must be of 512 x 512 or 1024 x 1024 size:
* `icon.png` icon is used on desktop. Should not have alpha channel.
* `icon_foreground.png` icon with transparent background is used as physical icon in some versions of Android.
* `main_logo.png` icon is displayed on Login and About screens.

7.3. Configuring Firebase project.
The project uses Firebase service for collecting analytics data. To build the app, you need to create Firebase project. It can be done [here](https://firebase.google.com/).
In the project, create 2 apps, for iOS and Android versions.
In the directory with app template, create `crashlytics` directory and place two files in it: `GoogleService-Info.plist` and `google-services.json` from respective apps in Firebase project.

8. To build iOS app:

8.1. In your Apple account, create id for AppGroup, with `App Groups` type selected when creating ID.
It can be done [here](https://developer.apple.com/account/resources/identifiers/list)

Also, you need to create app id and id for AppShareExtension module which is constructed as your app id + ".AppShareExtension".
For example, id = `my.app.id` id AppShareExtension = `my.app.id.AppShareExtension`

And activate `App Groups` for both ids, using the group created earlier

Then specify app id and group id in corresponding fields of `build_variant.yaml` file. There's no need to specify id AppShareExtension.
Make sure to specify Team ID. You can find it [here](https://developer.apple.com/account/#/membership)

8.2. To create certificates for signing iOS version, open XCode project. Click root project Runner in project structure, and in the new window opened, select Runner from Targets list, then select Signing & Capabilities. Certificates should be created automatically.
8.3. To build iOS version run `sh/build_ios.sh`
Package built will be placed to `build` directory, it can be uploaded to TestFlight using [Transporter](https://apps.apple.com/app/transporter/id1450874784?l=en&mt=12) application.

9. To build Android app:

9.1. Specify app id, for example `my.app.id` in `build_variant.yaml` file.

9.2. To sign the application, creating [signing key](https://developer.android.com/studio/publish/app-signing#generate-key) is required.
The file `key.jks`, which contains app signing key, needs to be placed to `sign` directory.
Edit the `key_template.properties` file and rename it into `key.properties`.

9.3. To build Android version run `build_android.sh`
Packages built will be placed to `build` directory.
