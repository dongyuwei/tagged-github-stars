import SwiftUI

struct PaginationView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["first"])
            }) {
                Text("First")
            }.disabled(self.store.pagination["first"] == nil)
            
            Button(action: {
                self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["prev"])
            }) {
                Text("Prev")
            }.disabled(self.store.pagination["prev"] == nil)
            
            Button(action: {
                self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["next"])
            }) {
                Text("Next")
            }.disabled(self.store.pagination["next"] == nil)
            
            Button(action: {
                self.store.loadStars(self.store.token, userName: self.store.basicUserInfo.name, url: self.store.pagination["last"])
            }) {
                Text("Last")
            }.disabled(self.store.pagination["last"] == nil)
        }.frame(width: 290)
    }
}
