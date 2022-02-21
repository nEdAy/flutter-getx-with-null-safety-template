# sunac_flutter

A new Flutter Module template project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).

## Branch name rule

• master - sunac flutter template release
• develop - sunac flutter template development
• release
    • allowed branch name: release/{projectKey}/{majorVersion}.{minorVersion}.0
    • example: release/zx/1.0.0, release/gx/1.0.0
• hotfix
    • allowed branch name: hotfix/{projectKey}/{majorVersion}.{minorVersion}.{patchVersionInMasterBranch+1}
    • example: hotfix/zx/1.0.1, release/gx/1.0.1
• feature
    • allowed branch name: feature/{projectKey}/{storyOrBugOrDefectOrIncidentName}/{domainAccountName}
    • example: feature/zx/add-flutter-to-android/sus12/

## GitFlow

• master and developer branch have to be with infinite lifecycle
• release branches could be multiple for different iteration
• hotfix branches could be created after production incident occurred
• master, develop, release and hotfix branches have to be protected
• feature branches are temporary ones for developers


## Unit Test

- flutter test // Executing unit tests
- flutter test --coverage // Generating coverage reports /coverage/Icov.info

• SonarQube plugin for Flutter / Dart
• https://github.com/insideapp-oss/sonar-flutter

Run analysis
Use the following commands from the root folder to start an analysis:

# Download dependencies
flutter pub get
# Run tests
flutter test --machine > tests.output
# Compute coverage (--machine and --coverage cannot be run at once...)
flutter test --coverage
# Run the analysis and publish to the SonarQube server
sonar-scanner