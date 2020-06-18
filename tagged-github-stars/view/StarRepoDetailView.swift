import SwiftUI

struct StarRepoDetailView: View {
    let starRepo: StarRepo
    
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        VStack(alignment: .leading) {
            StarRepoTagsView(starRepo: starRepo)
            StarRepoTopicsView(starRepo: starRepo)
            WebView(url: URL(string: starRepo.url)!)
        }.onAppear(perform: {
            self.store.getTopicsOfRepo(self.starRepo.fullName)
            self.store.getTags(self.starRepo.fullName)
        })
    }
}
