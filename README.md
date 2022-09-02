# flutter-getx-with-null-safety-template

<code>![null safety](https://img.shields.io/badge/null-safety-blue)</code>
<code>![flutter version](https://img.shields.io/badge/flutter-3.x-blue)</code>
<code>![getx version](https://img.shields.io/badge/getx-4.x-blue)</code>

A new Flutter Module template project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).

## Branch name rule

- master - flutter template release
- develop - flutter template development
- release
    - allowed branch name: release/{projectKey}/{majorVersion}.{minorVersion}.0
        - example: release/xxx/1.0.0
    - hotfix
        - allowed branch name: hotfix/{projectKey}/{majorVersion}.{minorVersion}.{patchVersionInMasterBranch+1}
        - example: hotfix/xxx/1.0.1
    - feature
        - allowed branch name: feature/{projectKey}/{storyOrBugOrDefectOrIncidentName}/{domainAccountName}
        - example: feature/xxx/add-flutter-to-android/nEdAy

## GitFlow

- master and developer branch have to be with infinite lifecycle
- release branches could be multiple for different iteration
- hotfix branches could be created after production incident occurred
- master, develop, release and hotfix branches have to be protected
- feature branches are temporary ones for developers


## Unit Test

- flutter test // Executing unit tests

- flutter test --coverage // Generating coverage reports /coverage/Icov.info

- SonarQube plugin for Flutter / Dart

    - https://github.com/insideapp-oss/sonar-flutter

- Run analysis

  Use the following commands from the root folder to start an analysis:

    - Download dependencies
        - flutter pub get
    - Run tests
        - flutter test --machine > tests.output
    - Compute coverage (--machine and --coverage cannot be run at once...)
        - flutter test --coverage
    - Run the analysis and publish to the SonarQube server
        - sonar-scanner


## Flutter 已使用依赖库

### dependencies:

#### flutter
- sdk: flutter
- 
#### flutter_localizations
- sdk: flutter

#### [GetX](https://github.com/jonataslaw/getx/blob/master/README.zh-cn.md)
- get: ^4.6.5
- Open screens/snackbars/dialogs/bottomSheets without context, manage states and inject dependencies easily with Get.

#### [HTTP client]()
- dio: ^4.0.6
- A powerful Http client for Dart, which supports Interceptors, FormData, Request Cancellation, File Downloading, Timeout etc.

#### [Retrofit](https://github.com/trevorwang/retrofit.dart/)
- retrofit: ^3.0.1+1
- retrofit.dart is an dio client generator using source_gen and inspired by Chopper and Retrofit.

#### [HTTP client Log](https://github.com/CuongNV12/flutter_pretty_dio_logger)
- flutter_pretty_dio_logger: ^2.0.2
- Show the correct json format, cUrl, easy to copy and use for many purposes.

#### [Dio network inspector](https://github.com/flutterplugin/dio_log)
- dio_log : ^2.0.4
- A plug-in that captures requests and views them within the application, providing functions such as request replication and JSON expansion

#### [Json generation](https://github.com/google/json_serializable.dart/tree/master/json_annotation)
- json_annotation: ^4.6.0
- Classes and helper functions that support JSON code generation via the `json_serializable` package.

#### [Log](https://github.com/leisim/logger)
- logger: ^1.1.0
- Small, easy to use and extensible logger which prints beautiful logs.

#### [Loading/Toast/Notification](https://github.com/MMMzq/bot_toast)
- bot_toast: ^4.0.3
- A really easy to use flutter toast library.Easy to use and feature rich.

#### [Sentry](https://pub.dev/packages/sentry)
- sentry: ^6.5.1
- A crash reporting library for Dart that sends crash reports to Sentry.io. This library supports Dart VM and Web. For Flutter consider sentry_flutter instead.

#### [Pull to Refresh](https://github.com/miquelbeltran/flutter_pulltorefresh)
- pull_to_refresh:
  git:
  url: https://github.com/miquelbeltran/flutter_pulltorefresh
  ref: 6d7fbdd
- a widget provided to the flutter scroll component drop-down refresh and pull up load.

#### [Extended Image](https://github.com/fluttercandies/extended_image)
- extended_image: ^6.2.1
- Official extension image, support placeholder(loading)/ failed state, cache network, zoom/pan, photo view, slide out page, editor(crop,rotate,flip), painting etc.

#### [Screen Util](https://github.com/OpenFlutter/flutter_screenutil)
- flutter_screenutil: ^5.5.3+2
- A flutter plugin for adapting screen and font size.Guaranteed to look good on different models

### dev_dependencies:

#### flutter_test:
- sdk: flutter

#### flutter_lints: ^2.0.1

#### [Build Runner](https://github.com/dart-lang/build/tree/master/build_runner)
- build_runner: ^2.2.0
- A build system for Dart code generation and modular compilation.

#### [Flutter gen runner](https://github.com/FlutterGen/flutter_gen)
- flutter_gen_runner: ^4.3.0
- The Flutter code generator for your assets, fonts, colors, … — Get rid of all String-based APIs.

#### [HTTP client generator](https://github.com/trevorwang/retrofit.dart/)
- retrofit_generator: ^4.0.3+1
- retrofit generator is an dio client generator using source_gen and inspired by Chopper and Retrofit.

#### [Json serializable](https://github.com/google/json_serializable.dart/tree/master/json_serializable)
- json_serializable: ^6.3.1
- Automatically generate code for converting to and from JSON by annotating Dart classes.