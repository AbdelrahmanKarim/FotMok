# 📱 Multi-Sport Center: Clean Architecture iOS Application

A comprehensive, high-performance iOS application that delivers real-time sports data for Football, Basketball, Tennis, and Cricket. Built on the foundations of Clean Architecture and reactive programming, this app aggregates data from the AllSports API to provide seamless access to live scores, fixtures, historical data, and deep-dive statistics for teams and players.

---

## 🏗 Architecture Overview

The project strictly follows Clean Architecture principles to separate concerns, ensure testability, and decouple business logic from the UI and frameworks. 

### 🧱 Architectural Layers

* **[Domain Layer]:** The core of the application. It contains the business models (Entities), Repository Interfaces, and Use Cases (Interactors). It is completely independent of UIKit, RxSwift, CoreData, or Alamofire.
* **[Data Layer]:** Responsible for data coordination. It implements the Repository interfaces defined in the Domain layer. It coordinates fetching data from remote sources (AllSports API via Alamofire) and caching/persisting data locally (CoreData).
* **[Presentation Layer]:** Handles UI rendering and user interaction. Implements the MVVM (Model-View-ViewModel) pattern, leveraging RxSwift for reactive, bidirectional data binding between views and view models.

### 🧪 Dependency Injection (DI)

* **[Factory Pattern]:** We utilize an explicit Factory Pattern for Dependency Injection. Every module (Screen/Feature) has a dedicated Factory responsible for instantiating the Network Clients, Local Data Stores, Repositories, ViewModels, and ViewControllers, injecting dependencies down through the initializer.

---

## 🏈 Core Features Covered Across All Sports

The application supports four major sports: Football, Basketball, Tennis, and Cricket. For each sport, the following features are robustly handled:

1.  **[Live Matches and Real-Time Updates]**
    Streams active, in-progress matches with real-time score updates, current match minutes, periods/quarters/innings, and live events (cards, goals, wickets, or point breakdowns).
2.  **[Upcoming Fixtures]**
    Organized schedules of future games filtered by date, league, or tournament. Users can browse upcoming match-ups and set reminders.
3.  **[Latest Match Results]**
    Historical overview of recently concluded matches, featuring final scores, match statistics, and game highlights.
4.  **[Head-to-Head (H2H) Analytics]**
    Comprehensive historical comparison when two teams or players are matched up. Displays previous meeting outcomes, win/loss percentages, and statistical trends to help users analyze matchups.
5.  **[Detailed Team Profiles]**
    Deep-dive views into specific clubs or franchises, highlighting their active roster, current league standings, overall form guides, and stadium/venue profiles.
6.  **[Player Profiles and Statistics]**
    Dedicated profiles for individual athletes displaying biographical information, current season metrics (goals, assists, points, ranking, wickets, etc.), and recent performance analytics.

---

## 🛠 Tech Stack and Third-Party Dependencies

The project relies on a carefully selected suite of industry-standard libraries to manage asynchronous streams, asset caching, network layers, and seamless UI transitions.

* **[RxSwift and RxCocoa]**
    Drives the reactive architecture. Used for binding UI components to ViewModels, transforming API data streams, and managing user interaction events cleanly without delegate boilerplate.
* **[Alamofire]**
    Handles the network layer. Built into a generic network client within the Data layer to process secure, asynchronous HTTP requests to the AllSports API endpoints.
* **[Kingfisher]**
    Manages remote image downloading and caching. Used across all collection and table views to lazily load and memory-cache team logos, player headshots, and country flags.
* **[SkeletonView]**
    Provides a modern, shimmering loading state instead of traditional blocky activity indicators while data is being fetched asynchronously from the API.
* **[NSPath / Routing]**
    Decouples navigation logic from ViewControllers, utilizing coordinated paths to push or present screens dynamically based on user flow.
* **[CoreData]**
    The local persistence layer. Used to cache offline data, store user favorites (teams, players, leagues), and ensure a functional offline-first experience when network connectivity is lost.

---

## 💾 Data Layer Architecture and API Mapping

The application connects to AllSports API using endpoints structured dynamically by sport and method.

### 🌐 Networking Architecture and Generic Client

Network calls use a dedicated router mapping out endpoint paths safely. Responses are decoded into Data Transfer Objects (DTOs) in the Data Layer, then mapped into pristine Domain Entities using dedicated Mapper utility classes.

### 🔄 CoreData Offline Persistence Flow

1.  UI requests data from the ViewModel.
2.  ViewModel invokes the Domain Use Case.
3.  The Repository checks network availability:
    * **[Online]:** Fetches latest data from Alamofire, updates the local CoreData cache, and emits the fresh data back to the UI via RxSwift.
    * **[Offline]:** Automatically falls back to querying CoreData, emitting the cached data seamlessly so the user notices zero disruption.

---

## 🚀 Getting Started

### 📋 Prerequisites

* Xcode 15 or newer
* iOS 15.0+ Deployment Target
* CocoaPods / Swift Package Manager (SPM)

### ⚙️ Installation

1.  Clone the repository:
    ```bash
    git clone [https://github.com/yourusername/multi-sport-clean-architecture.git](https://github.com/yourusername/multi-sport-clean-architecture.git)
    cd multi-sport-clean-architecture
    ```
2.  Open the project in Xcode (using the `.xcworkspace` if using CocoaPods, or `.xcodeproj` if using SPM).
3.  Locate the configuration or environment file (e.g., `NetworkConfig.swift`) and insert your unique AllSports API Key:
    ```swift
    struct NetworkConfig {
        static let apiKey = "YOUR_ALLSPORTS_API_KEY_HERE"
    }
    ```
4.  Build (`Cmd + B`) and Run (`Cmd + R`) the application on a simulator or physical device.
