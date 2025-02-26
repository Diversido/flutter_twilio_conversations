## 2.0.9
* Fix crash with `unregisterForNotification` if the token is empty
* Update example to use the latest Twilio Conversations JavaScript SDK [2.6.1](https://sdk.twilio.com/js/conversations/releases/2.6.1/docs/index.html)

## 2.0.6
* Fix crash with `typing`, `getUnreadMessagesCount`, `connectionStateChanged` and `connectionError` methods
* Refactored `sendMessage` to improve stability during conversation creation
    
## 2.0.5
* Update `getLastMessages` to return newest messages first and count backwards

## 2.0.4
* Added implementation for `registerForNotification` and `unregisterForNotification` methods
* Update signatures for `tokenExpired` and `tokenAboutToExpire` events

## 2.0.3
* Fixed JS Mapper - [#35](https://github.com/Diversido/flutter_twilio_conversations/issues/35)

## 2.0.2
* Fixed issue with messages containing Media

## 2.0.0+10
* First release of flutter_twilio_conversations web support
