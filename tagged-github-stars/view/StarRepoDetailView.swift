import SwiftUI

struct StarRepoDetailView: View {
    let starRepo: StarRepo
    
    var body: some View {
        VStack(alignment: .leading) {
            StarRepoTagsView(starRepo: starRepo)
            WebView(url: URL(string: starRepo.url)!)
        }
    }
}
