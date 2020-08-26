## tagged-github-stars
An App to manage your Github stars like a boss

![App](https://user-images.githubusercontent.com/112451/85295113-106e0900-b4d2-11ea-97d4-b368d9275754.png)


### Why a new App?
- Github project has Topics, but only Project Owner can add/remove/update the Topics.
- Tags are created by users who starred the project.

### Features
- Login via Github personal access token. The token is stored safely in Mac Keychain.app.
- Show all your Stars.
- Add/delete Tags for any github project.
- Search starred projects via Tags and Topics. Note: the App will first search the github remote API, then search tags in local SQLite, then merge and show the results. So the search may be slow, depends on the API and network.
- The App size is small, and the performance is good enough.

### Todo
Optimize the state management: Prefer using local state to reduce the re-render of the UI, thus continue improving the App performance. 

### Tech stack
- Swift
- SwiftUI
- SQLite
