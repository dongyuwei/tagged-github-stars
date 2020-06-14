import SwiftUI
import URLImage

let userModel = UserModel()

struct LoginView: View {
    @State var name: String = ""
    @State var token: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        HStack {
            TextField("Github Token:", text: self.$token)
                .cornerRadius(5)
            
            Button(action: {
                userModel.insertRecord(name: self.$name.wrappedValue, token: self.$token.wrappedValue)
                self.store.setToken(self.token)
                self.store.getUserInfo()
                self.store.loadStars()
            }) {
                Text("Login with Github personal token")
            }
            Button("How to create Github token?") {
                NSWorkspace.shared.open(URL(string: "https://github.com/settings/tokens/new")!)
            }
        }
    }
}

struct UserInfoView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack {
            if self.store.basicUserInfo.name != "" {
                HStack {
                    URLImage(URL(string: self.store.basicUserInfo.avatarUrl)!, placeholder: { _ in
                        Text(self.store.basicUserInfo.name)
                    })
                    Text(self.store.basicUserInfo.name)
                }
            } else {
                LoginView()
            }
        }
    }
}
