import SwiftUI

struct StarRepoItemView: View {
    let starRepo: StarRepo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(starRepo.fullName)
                    .bold()
            }
            
            Text(starRepo.description)
            HStack {
                Text("☆ \(starRepo.stargazersCount)")
            }
            Divider()
        }
    }
}
