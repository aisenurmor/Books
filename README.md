# 📚 Books App

An iOS application developed as a case study for the Kariyer.net iOS Developer position. The app features a modular architecture and provides book searching, detailed viewing, and favorite management capabilities.

## ✨ Features
- 🔍 Book search functionality
- 📖 Detailed book information viewing
- ⭐ Favorite books management
- 💾 Local data persistence
- 🏗️ Modular architecture
- ✅ Unit test coverage

## 🛠️ Technologies

- SwiftUI
- Combine
- VIPER Architecture Pattern
- Swift Package Manager
- XCTest

## 🏗️ Project Structure
The project consists of two main modules:

#### Core Package
- Core components
- Reusable UI components
- Network layer
- Data persistence operations

#### Feature Package
- 🏠 Home
- 📖 BookDetail
- ⭐ Favorites
- 🔍 Search

Each feature module is structured according to **VIPER** architecture:
- View
- Interactor
- Presenter
- Entity
- Router

## 🔧 Installation

Clone the project:

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

```bash
git clone https://github.com/aisenurmor/Books.git
```
- Open the project in Xcode
- Wait for dependencies to resolve
- Run the project

## 🧪 Testing
The project includes unit tests for feature modules. To run the tests:

Open the test navigator in Xcode

Click the test button or use *CMD + U* shortcut

## 📐 Architecture
The project implements the VIPER architectural pattern, providing:

* High testability
* Modular structure
* Separation of Concerns
* Reusability of components

## License

[MIT](https://choosealicense.com/licenses/mit/)
