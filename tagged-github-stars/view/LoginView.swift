import SwiftUI
import URLImage

struct LoginView: View {
    @State var name: String = ""
    @State var token: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Manage github stars with custom tags:")
            HStack {
                Spacer()
                
                TextField("Input Your Github Token", text: self.$token)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                
                Button(action: {
                    self.store.setToken(self.token)
                    self.store.getUserInfo(self.token)
                }) {
                    Text("Login with Github personal token")
                }
                Spacer()
            }.padding(20)
            
            Divider()
            
            Button("How to create Github token?") {
                NSWorkspace.shared.open(URL(string: "https://github.com/settings/tokens/new")!)
            }
            
            Spacer()
        }.frame(width: 500, height: 300)
    }
}
