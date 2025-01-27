# Soozen, an advanced timer app ⏱️

Soozen is a productivity-focused timer app built with **Flutter**. It allows users to set timers with customizable targets, track their progress by checking off tasks during the timer, and view detailed logs of completed targets with timestamps. All data is stored locally using **Hive Database**, ensuring fast performance and offline functionality.

![Soozen App Screenshot](https://raw.githubusercontent.com/rishitdutta/soozen/main/app_screenshot/screenshot.png) <!-- Add a screenshot of your app here -->

## Features ✨

- **Target-Based Timers**: Add multiple targets to a timer and check them off as you complete tasks.
- **Task Logs**: View a detailed log of when each target was completed during the timer.
- **History**: Store and review logs of previous timers for better productivity tracking.
- **Local Storage**: Uses **Hive Database** for efficient and fast local storage.
- **Intuitive UI**: Clean and user-friendly interface designed for seamless task management.

## Getting Started 🚀

Follow these steps to set up and run the Soozen Timer App on your local machine.

### Prerequisites

- **Flutter SDK**: Make sure you have Flutter installed on your machine. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **IDE**: Use **Android Studio**, **VS Code**, or any other IDE that supports Flutter development.
- **Emulator/Physical Device**: Set up an Android/iOS emulator or connect a physical device for testing.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rishitdutta/soozen.git
   cd soozen
   ```

2. **Install Dependencies**:
   Run the following command to install all the required dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Connect your emulator or physical device and run the app using:
   ```bash
   flutter run
   ```

4. **Build the App (Optional)**:
   To build the app for release, use:
   ```bash
   flutter build apk  # For Android
   flutter build ios  # For iOS
   ```

## How to Use the App 📱

1. **Start a Timer**:
   - Set a timer duration and add targets (tasks) you want to complete during the timer.
   
2. **Track Progress**:
   - As the timer runs, check off targets as you complete them.
   - The app will log the time when each target is completed.

3. **Review Logs**:
   - After the timer ends, view the logs of completed targets.
   - Access the history section to review logs from previous timers.

## Tech Stack 🛠️

- **Flutter**: For cross-platform app development.
- **Hive Database**: For lightweight and efficient local storage.
- **Provider**: For state management.
- **Intl**: For date and time formatting.

## Contributing 🤝

Contributions are welcome! If you'd like to contribute to Soozen, follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeatureName`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeatureName`).
5. Open a pull request.

Please ensure your code follows the project's coding standards and includes appropriate documentation.

## License 📄

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

Made with ❤️ by [Rishit Dutta](https://github.com/rishitdutta)  
Feel free to reach out for feedback or suggestions!
