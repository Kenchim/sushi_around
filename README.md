# Mobile app "Sushi Around" developed with Flutter

![featured_01](https://user-images.githubusercontent.com/61837814/191573218-df9dfe91-5082-43bd-b6ec-666c982b0ccb.png)


This app shows you sushi places around your location.

Google maps gives you tons of options and information, but sometimes they confuse you. Even this app is based on Google maps, but a lot of choices and details are reduced by this app settings, which guides you sushi place close to you. 

Sushi was originally food stands on the street, so not the destination of travels like nowadays. There are many ways to enjoy sushi of course, but through this app, you would enjoy the places rooted in daily life or chance encounters while traveling.

Sushi is around you. Let's open app and find yours.


## How to use

When you open this app, it automatically starts to search sushi shops around you and shows up to 20 places from google API.
The button "only open now" helps you to find the places which are open at the time. (Closed places are disappered from the list.)


![concept](https://user-images.githubusercontent.com/61837814/191573626-49ec1af6-122b-4b3b-b706-b9aa897e6073.png)


Once you tap the pictures of the list, you will see the information of the place. You can directly call or visiting website from the list, but if you want to get more details such as reviews, cost range or directions etc, you can tap "Open with Google Maps" and get more information.

![concept0](https://user-images.githubusercontent.com/61837814/191573717-2b5db482-0c9c-4e35-93af-62ea5ed4d333.png)


## API

Two APIs are used in this app.
- First, "Nearby Search" to get up to 20 placeIds (which is limited by google) with keyword of "sushi" and within roughly 500m radius from current position.
- Then secondly based on the placeIds, "Place Details" API are called.


