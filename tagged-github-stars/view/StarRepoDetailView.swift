import SwiftUI

struct StarRepoDetailView: View {
    let starRepo: StarRepo
    
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            StarRepoTagsView(starRepo: starRepo)
            WebView(url: URL(string: starRepo.url)!)
        }.onAppear(perform: {
            self.store.getTags(self.starRepo.fullName)
        })
    }
}
