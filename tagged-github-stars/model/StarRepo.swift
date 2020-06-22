import SwiftUI

class StarRepo: Identifiable, Hashable {
    static func == (lhs: StarRepo, rhs: StarRepo) -> Bool {
        return lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    var fullName: String
    var url: String
    var description: String
    var stargazersCount: Int
    
    init(fullName: String, url: String, description: String, stargazersCount: Int) {
        self.fullName = fullName
        self.url = url
        self.description = description
        self.stargazersCount = stargazersCount
    }
}
