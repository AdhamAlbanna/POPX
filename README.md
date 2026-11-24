# POPX

A social chat app for iOS built with **Swift** and **Firebase**. Users sign in, see who is online, and talk to each other in real time.

## Features
- Sign up and log in with email, **Google** or **Facebook**
- Online presence: see which users are currently online
- Real-time one-to-one chat built with **MessageKit**
- Messages, chat history and user profile screens
- Profile photos stored in Firebase Storage

## Tech
- Swift, UIKit, Storyboards
- Firebase: Authentication, Realtime Database, Storage
- Google Sign-In and Facebook Login
- MessageKit, RealmSwift, SDWebImage, JGProgressHUD, CodableFirebase
- CocoaPods for dependencies

## Run it
1. Clone the repository
2. Install the dependencies:
   ```bash
   pod install
   ```
3. Open `POPX.xcworkspace` in Xcode
4. Add your own Firebase project: replace `GoogleService-Info.plist` with the one from your Firebase console, and set up Google and Facebook sign-in for your bundle ID
5. Choose a simulator or device and press **Run**

## Author
Adham Albanna · [LinkedIn](https://www.linkedin.com/in/adhamalbanna/)
