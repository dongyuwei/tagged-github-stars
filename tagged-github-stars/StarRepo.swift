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
    
    init(_ fullName: String, url: String, description: String, stargazersCount: Int) {
        self.fullName = fullName
        self.url = url
        self.description = description
        self.stargazersCount = stargazersCount
    }
}


struct TopicModel: Identifiable, Hashable {
    var id: UUID
    var name: String
    
    static func == (lhs: TopicModel, rhs: TopicModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
