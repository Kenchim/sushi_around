# Mobile app "Sushi Around" developed with Flutter

This app shows you sushi places around your location.
Google maps gives you tons of options and information, but sometimes they confuses you.
With this app, you directly find places where you can eat sushi. 
All places on this app are within 1km from you, so it is not too hard to reach.

Sushi is around you. Let's open app and find yours.


## How to use

When you open this app, it automatically start to search sushi shops around you and show up to 20 places from google API.
The button "only open now" helps you to find the places which are open at the time. (Closed places are disappered from the list.)

<img width="200" alt="searching" src="https://user-images.githubusercontent.com/61837814/190010985-1194cb2e-d4e6-42c6-855c-f0f37458adb6.png"><img width="200" alt="list" src="https://user-images.githubusercontent.com/61837814/190010877-e0280614-4cb4-442c-9604-eae6a0b86774.png">


Once you tap the pictures of the list, you will see the information of the place. You can directly call or visiting website from the list, but if you want to get more details such as reviews, cost range or directions etc, you can tap "Open with Google Maps" and get more information.

<img width="200" alt="detail01" src="https://user-images.githubusercontent.com/61837814/190010924-2f23fa4d-a0f1-4e10-9040-f392f000389b.png"><img width="200" alt="detail02" src="https://user-images.githubusercontent.com/61837814/190010956-8fc8c3e5-6ff9-4f36-b812-2cc2143143fe.png">


##API

Two APIs are used in this app.
- First, "Nearby Search" to get up to 20 placeIds (which is limited by google) with keyword sushi and within 500m radius from current position.
- Then secondly based on the placeIds, "Place Details" API are called.

