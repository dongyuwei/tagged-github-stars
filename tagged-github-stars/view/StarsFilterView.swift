import SwiftUI

struct StarsFilterView: View {
    @State var filterText: String = ""
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("filter stars by tag/topic", text: self.$filterText, onCommit: {
                    self.store.filterStars(filterText: self.filterText)
                    self.filterText = ""
                }).textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Divider()
        }.padding(10)
         .frame(width: 280.0)
    }
}
