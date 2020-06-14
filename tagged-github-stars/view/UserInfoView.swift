import SwiftUI
import URLImage

struct LoginView: View {
    @State var name: String = ""
    @State var token: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        HStack {
            TextField("Input Your Github Token", text: self.$token)
                .cornerRadius(5)
            
            Button(action: {
                self.store.setToken(self.token)
                self.store.getUserInfo(self.token)
            }) {
                Text("Login with Github personal token")
            }
            Button("How to create Github token?") {
                NSWorkspace.shared.open(URL(string: "https://github.com/settings/tokens/new")!)
            }
        }
    }
}

struct BasicUserInfoView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        HStack {
            if self.store.basicUserInfo.avatarUrl == "" {
                Text("Loading...")
            } else {
                URLImage(URL(string: self.store.basicUserInfo.avatarUrl)!) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
                .frame(width: 100.0, height: 100.0)
                .cornerRadius(50)
                Text(self.store.basicUserInfo.name).bold()
            }
        }
    }
}

struct UserInfoView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack {
            if self.store.token != "" {
                BasicUserInfoView()
            } else {
                LoginView()
            }
        }
    }
}
