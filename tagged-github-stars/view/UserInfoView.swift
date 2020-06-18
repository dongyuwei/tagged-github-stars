import SwiftUI
import URLImage

struct UserInfoView: View {
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
                
                Button("Switch Account") {
                    self.store.clearCurrentToken()
                }
            }
        }
    }
}
