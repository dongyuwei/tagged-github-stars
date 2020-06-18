import Alamofire
import KeychainAccess
import SwiftUI

let TOKEN_KEY = "tagged-github-stars"

class StateStore: ObservableObject {
    let keychain = Keychain(service: "com.github.token")
    var tagModel: DBTagModel = DBTagModel()
    var repoModel: DBRepoModel = DBRepoModel()
    
    var allTopics: [String: [TopicModel]] = [:];
    
    @Published var token = ""
    @Published var stars: [StarRepo] = []
    @Published var basicUserInfo: BasicUserInfo = BasicUserInfo(name: "", avatarUrl: "")
    
    @Published var tags: [TagModel] = []
    @Published var topics: [TopicModel] = []

    
    
    func setToken(_ token: String) {
        self.token = token
        
        do {
            try keychain.set(token, key: TOKEN_KEY)
        } catch {
            print("failed to save token", error)
        }
    }
    
    func addStarItem(_ item: StarRepo) {
        stars.append(item)
    }
    
    func getStoredToken() -> String {
        let value = try? keychain.getString(TOKEN_KEY)
        let token = value ?? ""
        self.token = token
        return token
    }
    
    func buildHeaders(_ token: String) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)",
            "Accept": "application/vnd.github.mercy-preview+json",
        ]
        return headers
    }
    
    func getUserInfo(_ token: String) {
        AF.request("https://api.github.com/user", headers: buildHeaders(token))
            .responseJSON { response in
                if let result = response.value {
                    let user = result as! NSDictionary
                    let userName = user["name"]! as! String
                    self.basicUserInfo = BasicUserInfo(name: userName, avatarUrl: user["avatar_url"]! as! String)
                    
                    self.loadStars(token, userName: userName)
                }
            }
    }
    
    func getTopicsOfRepo(_ repoFullName: String) {
        let cachedTopics = self.allTopics[repoFullName]
        if(cachedTopics != nil) {
            self.topics = cachedTopics!
            return;
        }
        
        AF.request("https://api.github.com/repos/\(repoFullName)/topics", headers: buildHeaders(token))
        .responseJSON { response in
            if let result = response.value {
                let data = result as! NSDictionary
                let topics = data["names"] as! NSArray
                print("###\(repoFullName)  topics", topics)
                var list: [TopicModel] = []
                for topic in topics {
                    list.append(TopicModel(id: UUID(), name: topic as! String))
                }
                self.topics = list
                self.allTopics[repoFullName] = list
            }
        }
    }
    
    func getTopicsOfCurrentRepo() -> [TopicModel] {
        return self.topics
    }
    
    func loadStars(_ token: String, userName: String) {
        AF.request("https://api.github.com/users/\(userName)/starred", headers: buildHeaders(token))
            .responseJSON { response in
                if let links = response.response?.allHeaderFields["Link"] as? String {
                    print("=======link====")
                    print(links)
                    print("=======link====")
                }
                
                if let result = response.value {
                    let stars = result as! NSArray
                    self.stars = []
                    
                    stars.forEach { item in
                        let obj = item as! NSDictionary
                        let fullName = obj["full_name"]! as! String
                        let url = obj["html_url"]! as! String
                        let description = obj.value(forKey: "description") as? String ?? ""
                        let stargazersCount = obj["stargazers_count"]! as! Int
                        
                        self.addStarItem(StarRepo(
                            fullName: fullName,
                            url: url,
                            description: description,
                            stargazersCount: stargazersCount))
                    }
                    
                    self.repoModel.insertRepos(self.stars)
                }
            }
    }
    
    func getTags(_ repoName: String) -> [TagModel] {
        let tagModels = tagModel.getTagModels(repoName)
        self.setTags(tagModels)
        return tagModels
    }
    
    func setTags(_ tags:  [TagModel]){
        self.tags = tags
    }
    
    func addTag(_ tagInput: String, repo: String) {
        let tags = tagInput.replacingOccurrences(of: "[,\\s\n]+", with: " ", options: .regularExpression, range: nil)
            .components(separatedBy: " ")
        tagModel.insertTags(tags, repo: repo)
        
        self.setTags(self.getTags(repo))
    }
    
    func deleteTag(_ tag: String, repo: String) {
        tagModel.deleteTag(tag: tag, repo: repo)
        
        self.setTags(self.getTags(repo))
    }
    
    func filterStars(filterText: String) {
        let tag = filterText.trimmingCharacters(in: .whitespacesAndNewlines)
        if(tag == "") {
            return
        }
        let tagModels = self.tagModel.getTagModelsByTag(tag)
        let repos: [StarRepo] = self.repoModel.getReposByTagModels(tagModels)
        var added = Set<StarRepo>()
        var starRepos = [StarRepo]()
        for repo in repos {
            if(!added.contains(repo)) {
                added.insert(repo)
                starRepos.append(repo)
            }
        }
        self.stars = starRepos
        
        print("----filterStars ", filterText, tagModels, self.stars)
    }
    
    func reloadStars() {
        self.loadStars(self.token, userName: self.basicUserInfo.name)
    }
}
