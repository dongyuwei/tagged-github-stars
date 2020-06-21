import SwiftUI

struct PaginationView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        HStack {
            Spacer()
            if ((self.store.pagination["first"]) != nil) {
                Button(action: {
                    self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["first"])
                }) {
                    Text("First")
                }
            }
            
            if((store.pagination["prev"]) != nil) {
                Button(action: {
                    self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["prev"])
                }) {
                    Text("Prev")
                }
            }
            
            if((store.pagination["next"]) != nil) {
                Button(action: {
                    self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["next"])
                }) {
                    Text("Next")
                }
            }

            if((store.pagination["last"]) != nil) {
                Button(action: {
                    self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["last"])
                }) {
                    Text("Last")
                }
            }
        }.frame(width: 290)
    }
}
