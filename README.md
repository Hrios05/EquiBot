# EquiBotFinal

## Overview

EquiBotFinal is an iOS application designed to simplify navigating California law. It provides a user-friendly interface for interacting with a chatbot that can answer legal questions and provide relevant information. The app integrates with Firebase for user authentication and data storage, and uses a local Python server to process chatbot requests.



<img width="205" alt="Screenshot 2025-04-06 at 4 43 50 AM" src="https://github.com/user-attachments/assets/90753387-77f8-41d1-8ea8-702579601b6c" /><img width="229" alt="Screenshot 2025-04-06 at 4 45 47 AM" src="https://github.com/user-attachments/assets/016ea1d2-a4ec-4968-b609-a945db58d9f1" /><img width="223" alt="Screenshot 2025-04-06 at 4 46 55 AM" src="https://github.com/user-attachments/assets/5d82ec60-35f5-4ffc-b330-7b2fe2cacaba" />

## Features

-   **Chat History:** View a history of your conversations with EquiBot.
-   **Saved Websites:** Save and access useful legal resources.
-   **User Authentication:** Secure user accounts managed with Firebase.
-   **Interactive Chatbot:** Get answers to your legal questions through an interactive chatbot interface.
-   **Link Formatting:** Automatically format and save links provided by the chatbot.
-   **Dynamic Scrolling:** The chat interface automatically scrolls to the bottom as new messages are received.

## Technologies Used

-   **SwiftUI:** For building the user interface.
-   **Firebase:** For user authentication and data storage (Firestore).
-   **Python (Flask):** For the backend chatbot server.
-   **URLSession:** For making network requests to the chatbot server.


## Requirements

-   Xcode 15+
-   iOS 15.0+
-   Firebase account and project
-   Python 3.6+

## Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone [repository URL]
    cd EquiBotFinal
    ```

2.  **Firebase Setup:**

    -   Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    -   Enable Firestore and Authentication.
    -   Download the `GoogleService-Info.plist` file and add it to your Xcode project.

3.  **Configure Xcode Project:**

    -   Open the `EquiBotFinal.xcodeproj` in Xcode.
    -   Add the `GoogleService-Info.plist` file to your project.
    -   Install Firebase SDK using Swift Package Manager.

4.  **Backend Setup (Python Chatbot Server):**

    -   Navigate to the chatbot server directory.
    -   Install the required Python packages:

        ```bash
        pip install flask
        ```

    -   Run the Flask server:

        ```bash
        python app.py
        ```

5.  **Run the iOS App:**

    -   Build and run the `EquiBotFinal` project in Xcode on a simulator or physical device.

## Architecture

The app follows a Model-View-ViewModel (MVVM) architecture.

-   **Views:** SwiftUI views for the user interface (`HomePageView`, `TabsView`, `ChatHistoryView`, `SavedWebsitesView`, etc.).
-   **Models:** Data models for messages (`ChatMessage`), user data (`User`).
-   **ViewModels:** (Implicit) Logic within the views to manage state and interact with Firebase and the chatbot server.

## Code Structure

-   `ContentView.swift`: Initial view displaying the app's logo and name.
-   `HomePageView.swift`: Main chat interface with message display and input.
-   `TabsView.swift`: Tabbed interface for accessing chat history and saved websites.
-   `ChatHistoryView.swift`: Displays the chat history.
-   `SavedWebsitesView.swift`: Manages and displays saved websites.
-   `AuthController.swift`: Handles user authentication and data saving.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

[Choose a license, e.g., MIT License]
