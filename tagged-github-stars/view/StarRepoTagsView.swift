import SwiftUI

struct StarRepoTagsView: View {
    let starRepo: StarRepo
    
    @State var tag: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("add new tags, separated with comma or space", text: self.$tag, onCommit: {
                        self.store.addTag(self.tag, repo: self.starRepo.fullName)
                        self.tag = ""
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.store.addTag(self.tag, repo: self.starRepo.fullName)
                    self.tag = ""
                }) {
                    Text("Add New Tag")
                }
            }
            Divider()
            Text("Tags:")
            List {
                HStack(spacing: 20) {
                    ForEach(self.store.getTags(self.starRepo.fullName), id: \.self) { item in
                        
                        Button(action: {
                            self.store.deleteTag(item.tag, repo: self.starRepo.fullName)
                        }) {
                            Text("\(item.tag)  X")
                        }.onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
            }
        }.padding(10)
        .frame(height: 200.0)
    }
}
