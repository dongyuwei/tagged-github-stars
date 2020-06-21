## tagged-github-stars
An App to manage your Github stars like a boss

### Why a new App?
- Github project有 Topics，是Project Owner 自己添加管理的，只能添加英文字符。
- Tags是是站在用户的角度来看的，关注 project 的人可以按需添加。用户自定义Tag标签是 Topics 的有益补充。
- 用户可以通过 Topics 和 Tags 来搜索自己关注的Github项目（Stars）

### Features
- 通过 Github personal access token 登录 app，可以切换账号（token 储存在本机 keychain 内，比较安全）；
- 显示自己的 stars，显示自己关注的开源项目；
- 给关注的单个项目添加自定义标签，支持批量添加多个标签；可以删除标签；
- 可以按自定义标签搜索关注的项目

### 技术栈
- SwiftUI
- sqlite
