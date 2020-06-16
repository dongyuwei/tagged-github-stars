import SwiftUI

struct StarRepoTopicsView: View {
    let starRepo: StarRepo
    
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Topics:")
            Divider()
            List {
                HStack(spacing: 20) {
                    ForEach(self.store.getTopicsOfCurrentRepo(),  id: \.self) { topic in
                        Text(topic.name)
                    }
                }
            }
        }.padding(10)
    }
}
