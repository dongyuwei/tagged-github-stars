import SwiftUI

struct RepositoryView: View {
    let repository: StarItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(repository.fullName)
                    .bold()
            }
            
            Text(repository.description)
            HStack {
                Text("☆ \(repository.stargazersCount)")
            }
            Divider()
        }
    }
}
