import SwiftUI

struct StarsFilterView: View {
    @State var filterText: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("filter my stars", text: self.$filterText, onCommit: {
                    self.store.filterStars(filterText: self.filterText)
                    self.filterText = ""
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.store.filterStars(filterText: self.filterText)
                    self.filterText = ""
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
