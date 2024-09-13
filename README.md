# Bckgrd

Bckgrd is a macOS application that provides daily quotes and allows users to change their desktop background. It runs in the background and can be accessed via the menu bar.

## Features

- Daily quotes delivered at noon
- Random background changer
- Menu bar integration for easy access

## Requirements

- macOS 11 or later
- Xcode 12.0 or later (for development)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/Bckgrd.git
   ```
2. Open the project in Xcode:
   ```
   cd Bckgrd
   open Bckgrd.xcodeproj
   ```
3. Build and run the project in Xcode.

## Usage

After launching the app:

1. The app icon will appear in the menu bar.
2. Click on the icon to access the menu.
3. Select "Change" to set a random background.
4. Daily quotes will be delivered as notifications at noon.

## Project Structure

- `BckgrdApp.swift`: Main app file and AppDelegate
- `ContentView.swift`: Main view of the app
- `DailyQuote.swift`: Handles fetching and scheduling of daily quotes
- `Notification.swift`: Manages notification handling
- `Utilities.swift`: Contains utility functions
- `WordOfTheDay.swift`: Handles word of the day functionality
- `Unsplash.swift`: Manages interaction with Unsplash API for backgrounds

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.