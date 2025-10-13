# Tow Management System UI

## Project Overview

**Tow Management System UI** is a cross-platform (Flutter) app that allows 
tow service operators to manage jobs and invoicing for their business.

## Getting Started
To begin supporting, please familiarize yourself with the documentation below.

1. Setup Environment
2. Run Application
3. Update Code


### 1. Setup Environment

#### Install Flutter (v3.24.3)
* Follow the instructions [here](https://docs.flutter.dev/get-started/install/macos/mobile-ios#install-the-flutter-sdk)

### 2. Run Application

#### Web Instructions
1. Navigate to the project root
2. Run command:
```shell
flutter run -d chrome
```
#### IOS Instructions
1. Navigate to the project root
2. Start iOS simulator:
```shell
open -a Simulator
```
3. Run app on simulator
```shell
flutter run
```


*NOTE:* Both platform simulators can be open however you will need to "hot reload" them individually when running in multiple terminals

### 3. Update Code

The UI application source code is located in the `lib/` directory and contains all Dart code that is shared across all supported platforms (iOS, Android, Web, and Desktop).

The codebase is organized according to a layered architecture to improve maintainability, scalability, and testability. Below is an overview of the main directories and their roles:

- `/models`: Contains the data structures and class definitions used throughout the application. Each file defines a single data model or schema (e.g., `Vehicle`, `User`, `MaintenanceRecord`).

- `/views`: Holds all UI screens and widgets that define what is presented to the user. Views typically depend on data from the repository and include the logic for displaying and conditionally rendering screens or components.

- `/controllers`: Handles the retrieval and caching of data from local storage or the service layer. It acts as the abstraction between the view and data sources.

- `/service`: Contains the integration logic with backend APIs and third-party services such as authentication, Stripe, push notifications, etc. This layer ensures that the application can communicate with external systems in a consistent and reusable way.

This structure enables a clear separation of concerns and supports modular development across feature areas.

