import SwiftUI

struct StarRepoTagsView: View {
    let starRepo: StarRepo
    @State var tag: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("new tag", text: self.$tag)
                    .cornerRadius(5)
                
                Button(action: {
                    self.store.addTag(self.tag, repo: self.starRepo.fullName)
                }) {
                    Text("Add New Tag")
                }
            }
            Divider()
            List {
                HStack(spacing: 20) {
                    ForEach(self.store.tags, id: \.self) { item in
                        Text(item.tag)
                    }
                }
            }
        }
    }
}
