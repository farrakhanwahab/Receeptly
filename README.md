# Receeptly - Receipt Generator

A simple mobile app for generating professional receipts with multiple layout styles. The app features a clean, modern light theme.

## Features

- **Multiple Receipt Styles**: Choose from Bank, Restaurant, Retail, or Document-style receipts
- **Live Preview**: See your receipt in real-time as you edit
- **Export Options**: Save receipts as PDF or images
- **Customization**: Add merchant information, items, tax rates, and currency options (all managed in Settings)
- **Receipt History**: Save and manage your recent receipts
- **Clear All Data**: Easily reset all settings and receipts from the Settings page
- **Modern UI**: Clean, light theme with Montserrat font

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/farrakhanwahab/Receeptly
cd Receeptly
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

1. **Create Receipt**: Use the stepper form to enter merchant information, add items, and select a receipt style
2. **Preview**: Switch to the preview tab to see your receipt in real-time
3. **Export**: Use the menu options to export as PDF, image, or share
4. **History**: View and manage your saved receipts
5. **Settings**: Manage merchant info, tax rates, and currency. Use 'Clear All Data' to reset the app.

## Receipt Styles

- **Classic**: Classic, professional layout
- **Modern**: Modern, itemized layout
- **Simple**: Simple, till-style format
- **Document**: Formal document/invoice style

## Dependencies

- `provider`: State management
- `pdf`: PDF generation
- `screenshot`: Image capture for export
- `share_plus`: File sharing
- `file_picker`: Logo upload functionality
- `google_fonts`: Montserrat font integration
- `intl`: Date and currency formatting