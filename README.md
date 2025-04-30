
# 🌕 CoinRanking iOS App

An iOS app that displays real-time market data for the top 100 cryptocurrencies, including price, performance, and detailed analytics — built using Swift, UIKit, and SwiftUI. The app supports swiping to favorite coins and filtering by price or performance.

---

## 📲 App Screenshots

| Splash | Home (Top 100) | Coin Detail | Favorites |
|--------|----------------|-------------|-----------|
| ![Splash Screenshot](Screenshots/splash.png) | ![Home Screenshot](Screenshots/home.png) | ![Detail Screenshot](Screenshots/detail.png) | ![Favorites Screenshot](Screenshots/favorites.png) |

---

## 📦 Features

### 🔢 Screen 1: Top 100 Coins List
- Paginated (20 coins per page).
- Swipe to **favorite/unfavorite**.
- Filter by:
  - Highest price
  - Best 24-hour performance
- Display includes:
  - Icon
  - Name
  - Current Price
  - 24-hour % change (green/red)

### 📊 Screen 2: Coin Details
- Coin name, price, statistics
- Interactive performance chart with time filters

### ❤️ Screen 3: Favorites
- List of all favorited coins
- Swipe to unfavorite
- View full details of each coin

---

## 🛠 Tech Stack

- **Swift 5**
- **UIKit** – navigation, table views
- **SwiftUI** – lightweight reusable views
- **SPM(SwiftPackageManager)** – dependency manager for Lottie
- **Network.framework** – for real-time connectivity check
- **MVVM** – maintainable architecture

---

## 🔧 Setup Instructions

### ✅ Requirements:
- Xcode 14 or later
- iOS 14+ simulator or device

### 📥 Installation

1. **Clone this repo**
   ```bash
   https://github.com/kelvinofula/CoinRankingApp.git
   cd coinranking
   ```

2. **Create a free CoinRanking API account**
   - Visit [https://developers.coinranking.com/](https://developers.coinranking.com/)
   - Sign up and generate your **Test API Key**

3. **Configure API Key securely**
   - In the Xcode project root, create a new file: `secrets.xcconfig`
   - Copy contents from `secrets-sample.xcconfig` and replace with your real API key:
     ```
     API_KEY=your_api_key_here
     ```
   - In Xcode: 
     - Go to **Project > Info > Configurations**
     - Add `secrets.xcconfig` to the **Debug** configuration via the **File Inspector**

4. **Run the project**
   - Open `CoinRanking.xcodeproj`
   - Build and run on a simulator or connected device

---

## ✅ Good Practices Used

- Immediate network status using `monitor.currentPath.status` to avoid false negatives
- Swipe-to-favorite updates both UI and data store safely
- Clean MVVM separation between view, presenter, and store
- Memory-safe singletons (e.g. `NetworkMonitor.shared`)
- Lottie animation integrated via Swift Package Manager

---

## 🧪 Testing

- Unit tests for:
  - FavoritesStore logic
  - Presenter-state formatting
- Placeholder test targets included for extensibility

---

## 📄 Assumptions & Design Choices

- In-memory favorites store for simplicity (can be extended with CoreData or UserDefaults)
- NavigationController used for view transitions
- Placeholder Lottie animation for splash
- Simple bar chart with toggle buttons in the coin detail (replaceable with Charts framework)

---

## ⚠️ Known Issues

- If API key is not configured properly, the app will fail silently. Confirm via console logs.
- Some chart animations are simulated and do not reflect real-time data yet.

---

## 🧠 Challenges & How I Solved Them

| Challenge | Solution |
|----------|----------|
| `NWPathMonitor` reports false on first check | Used `monitor.currentPath.status` for immediate snapshot |
| Inconsistent state after swipe favorite | Synced UI state with model + refreshed data source |
| Lottie integration in UIKit views | Used `LottieAnimationView` and animated it on the splash screen |

---

## ✨ Future Enhancements

- Persist favorites using `UserDefaults` or `CoreData`
- Integrate real-time graph with `Charts` or `Swift Charts`
- Add search functionality to filter coins
- Dark mode and accessibility features

---

## 📬 Submission

This app was built for an iOS take-home assessment and demonstrates:

- UIKit + SwiftUI integration
- API pagination and filtering
- State management and animation
- Production-quality practices

---

## 👨‍💻 Author

Kelvin Ofula  
[LinkedIn](https://www.linkedin.com/in/kelvin-ofula)  
[GitHub](https://github.com/kelvinofula)

---

## 🪪 License

This project is open-sourced under the MIT License.
