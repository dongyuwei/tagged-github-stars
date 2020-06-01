import SwiftUI

struct RepositoryView: View {
    let repository: StarItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
//                Image(systemName: "doc.text")
                Text(repository.fullName)
                    .bold()
            }
            
            Text(repository.description)
            HStack {
//                Image(systemName: "star")
                Text("\(repository.stargazersCount)")
            }
        }
    }
}
