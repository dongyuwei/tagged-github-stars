import SwiftUI

class StarItem: Identifiable, Hashable {
    static func == (lhs: StarItem, rhs: StarItem) -> Bool {
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

class StateStore: ObservableObject {
    @Published var userName = ""
    @Published var stars: [StarItem] = []
    
    func addStarItem(_ item: StarItem) {
        stars.append(item)
    }
}
