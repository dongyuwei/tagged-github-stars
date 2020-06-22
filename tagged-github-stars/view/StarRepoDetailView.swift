import SwiftUI

struct StarRepoDetailView: View {
    let starRepo: StarRepo
    
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            StarRepoTagsView(starRepo: starRepo)
            GeometryReader { g in
                ScrollView {
                    WebView(url: URL(string: self.starRepo.url)!)
                        .frame(height: g.size.height)
                        .tag(1)
                }.frame(height: g.size.height)
            }
            
        }.onAppear(perform: {
            self.store.getTags(self.starRepo.fullName)
        })
    }
}
