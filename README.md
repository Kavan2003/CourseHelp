

CourseHelp is a Flutter-based application designed to assist instructors in creating high-quality online courses efficiently. This project aims to reduce the time and effort required to design and produce online courses by providing various copilots for translating content, adding multimedia elements, and generating lecture notes.

## Features

- **Course Outline Generation**: Automatically generate course outlines based on provided titles and descriptions.
- **Content Translation**: Translate course content into multiple Indian languages using the Sarvam Translation API.
- **Multimedia Integration**: Add images, animations, and voiceovers to course content.
- **Lecture Notes**: Generate lecture notes to accompany course materials.
- **Voiceover and TTS**: Use Text-to-Speech (TTS) and Automatic Speech Recognition (ASR) to add voiceovers to course content.
- **Deployment Options**: Can be deployed as a Chrome extension, web app, or smartphone app.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Xcode (for mobile development)
- Node.js and npm (for web development)
- Access to Sarvam APIs (ASR, Translation, TTS, Audio LM)

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/coursehelp.git
    cd coursehelp
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Set up environment variables**:
    - Create a [`.env`] file in the root directory.
    - Add your API keys:
      ```env
      API_KEY=your_sarvam_api_key
      ```

4. **Run the application**:
    ```sh
    flutter run
    ```

## Usage

1. **Generate Course Outline**:
    - Enter the course title and description on the home screen.
    - Click "Generate Outline" to automatically create a course outline.

2. **Manual Course Outline**:
    - Enter the course title and description.
    - Click "Manual Outline" to create a custom course outline.

3. **Add Multimedia**:
    - Use the provided copilots to add images, animations, and voiceovers to your course content.

4. **Translate Content**:
    - Use the translation copilot to translate your course content into multiple Indian languages.

## Deployment

### Web

1. **Build the web app**:
    ```sh
    flutter build web
    ```

2. **Serve the web app**:
    ```sh
    flutter serve
    ```

### Mobile

1. **Build the mobile app**:
    ```sh
    flutter build apk
    ```

2. **Install the APK on your device**:
    ```sh
    flutter install
    ```

### Chrome Extension

1. **Build the Chrome extension**:
    ```sh
    flutter build web
    ```

2. **Load the extension in Chrome**:
    - Open Chrome and go to `chrome://extensions/`.
    - Enable "Developer mode".
    - Click "Load unpacked" and select the `build/web` directory.

## Contributing

We welcome contributions! 

## Acknowledgements

- [Gemini API](https://gemini.api)
- [Sarvam API](https://sarvam.api)

## Contact

For any inquiries, please contact [kavanthosani2003@gmail.com](mailto:kavanthosani2003@gmail.com).

---
