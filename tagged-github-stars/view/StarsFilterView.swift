import SwiftUI

struct StarsFilterView: View {
    @State var filterText: String = ""
    @State var focused: Bool = false
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("filter my stars", text: self.$filterText, onEditingChanged: { editingChanged in
                    if editingChanged {
                        self.focused = true
                    }
                }, onCommit: {
                    if self.focused {
                        self.store.filterStars(filterText: self.filterText)
                    }
                    self.focused = false
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.store.filterStars(filterText: self.filterText)
                }) {
                    Text("Search")
                }
                
                Button(action: {
                    self.store.reloadStars()
                    self.filterText = ""
                }) {
                    Text("Reset")
                }
            }
            Divider()
        }.padding(10)
            .frame(width: 290.0)
    }
}
