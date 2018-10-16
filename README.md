# Project 5 - *My-Twitter-Version*

**My-Twitter-Version** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User sees app icon in home screen and styled launch screen. (1pt)
- [x] User can sign in using OAuth login flow. (1pt)
- [x] User can Logout. (1pt)
- [x] Create Data Models for User and Tweet. (1pt)
- [x] User can view last 20 tweets from their home timeline with the user profile picture, username, tweet text, and timestamp. (2pts)
- [x] User can pull to refresh. (1pt)
- [x] User can tap the retweet and favorite buttons in a tweet cell to retweet and/or favorite a tweet. (2pts)
- [x] Using AutoLayout, the Tweet cell should adjust it's layout for iPhone 7, Plus and SE device sizes as well as accommodate device rotation. (1pt)

The following **stretch** features are implemented:

- [x] The current signed in user will be persisted across restarts. (1pt)
- [x] Each tweet should display the relative timestamp for each tweet "8m", "7h". (1pt)
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. (1pt)
- [x] Links in tweets are clickable. (2pts)
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client. (2pts)

The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!

  1. show images, videos from tweets.
  2. go to someone's profile and see their posts.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How does stack view really works for auto layout, I did use it but I wanted to do more and not sure how.
2. How request token, authorize and access_token is acquired and how they do the whole authorization process.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div style="display: inline-block;">
<img float="left" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/46993869-b5222b80-d0df-11e8-8070-1361cb537a77.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img float="left" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/46993885-ca975580-d0df-11e8-947b-11a3aa82d5c8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img float="right" width="320" height="600" src='https://user-images.githubusercontent.com/16315708/46993969-337ecd80-d0e0-11e8-8ae8-1445fe051420.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<div/>

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

  1. I guess understanding the code already written for us. 
  2. Why do the code creates an instance inside its own class to get to their funcs instead of making those funcs static ?

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateToolsSwif'](https://github.com/MatthewYork/DateTools) - allows date to show as time ago ex. 2d, 3h
- [ActiveLabel](https://github.com/optonaut/ActiveLabel.swift) - allows labels to be segregated with functions as well. 

## License

Copyright [2018] [Luis Mendez]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
