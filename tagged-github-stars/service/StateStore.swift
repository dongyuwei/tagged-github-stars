import Alamofire
import KeychainAccess
import SwiftSoup
import SwiftUI

let TOKEN_KEY = "tagged-github-stars"

class StateStore: ObservableObject {
    let keychain = Keychain(service: "com.github.token")
    var tagModel: DBTagModel = DBTagModel()
    var repoModel: DBRepoModel = DBRepoModel()
    
    @Published var token = ""
    @Published var stars: [StarRepo] = []
    @Published var basicUserInfo: BasicUserInfo = BasicUserInfo(name: "", avatarUrl: "")
    @Published var tags: [TagModel] = []
    @Published var pagination: [String: String] = [:]
    @Published var loading: Bool = false
    @Published var loginError: String = ""
    
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
    
    func clearCurrentToken() {
        do {
            try keychain.remove(TOKEN_KEY)
            token = ""
        } catch {
            print("error: \(error)")
        }
    }
    
    func buildHeaders(_ token: String) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)",
            "Accept": "application/json",
            "User-Agent": "dongyuwei",
        ]
        return headers
    }
    
    func getUserInfo(_ token: String) {
        AF.request("https://api.github.com/user", headers: buildHeaders(token))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.value {
                        self.loginError = ""
                        self.setToken(token)
                        let user = result as! NSDictionary
                        let userName = user["name"]! as! String
                        self.basicUserInfo = BasicUserInfo(name: userName, avatarUrl: user["avatar_url"]! as! String)
                        
                        self.loadStars(token, userName: userName)
                    }
                case let .failure(error):
                    self.loginError = "Failed to login, please input valid token."
                    print("Failed to get user info", error)
                }
            }
    }
    
    func parseLinks(_ links: String) -> [String: String] {
        var dictionary: [String: String] = [:]
        links.components(separatedBy: ",").forEach({
            let components = $0.components(separatedBy: "; ")
            dictionary[components[1].replacingOccurrences(of: "rel=", with: "").replacingOccurrences(of: "\"", with: "")] = components[0].replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .replacingOccurrences(of: " ", with: "")
        })
        return dictionary
    }
    
    func loadStars(_ token: String, userName: String, url: String? = nil) {
        loading = true
        let url2 = url ?? "https://api.github.com/users/\(userName)/starred?per_page=100"
        AF.request(url2, headers: buildHeaders(token))
            .responseJSON { response in
                if let links = response.response?.allHeaderFields["Link"] as? String {
                    self.pagination = self.parseLinks(links)
                }
                
                if let result = response.value {
                    let stars = result as! NSArray
                    var starRepos: [StarRepo] = []
                    stars.forEach { item in
                        let obj = item as! NSDictionary
                        let fullName = obj["full_name"]! as! String
                        let url = obj["html_url"]! as! String
                        let description = obj.value(forKey: "description") as? String ?? ""
                        let stargazersCount = obj["stargazers_count"]! as! Int
                        
                        starRepos.append(StarRepo(
                            fullName: fullName,
                            url: url,
                            description: description,
                            stargazersCount: stargazersCount))
                    }
                    self.loading = false
                    self.stars = starRepos
                    
                    self.repoModel.insertRepos(self.stars)
                }
            }
    }
    
    func getTags(_ repoName: String) -> [TagModel] {
        let tagModels = tagModel.getTagModels(repoName)
        setTags(tagModels)
        return tagModels
    }
    
    func setTags(_ tags: [TagModel]) {
        self.tags = tags
    }
    
    func addTag(_ tagInput: String, repo: String) {
        let tags = tagInput.components(separatedBy: " ").map {
            $0.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        print("tagInput:", tagInput, repo, tags)
        tagModel.insertTags(tags, repo: repo)
        
        setTags(getTags(repo))
    }
    
    func deleteTag(_ tag: String, repo: String) {
        tagModel.deleteTag(tag: tag, repo: repo)
        
        setTags(getTags(repo))
    }
    
    func filterStarsFromLocalDB(_ filterText: String) -> [StarRepo] {
        let tag = filterText.trimmingCharacters(in: .whitespacesAndNewlines)
        if tag == "" {
            return []
        }
        
        let tagModels = tagModel.getTagModelsByTag(tag)
        let repos: [StarRepo] = repoModel.getReposByTagModels(tagModels)
        var added = Set<StarRepo>()
        var starRepos = [StarRepo]()
        for repo in repos {
            if !added.contains(repo) {
                added.insert(repo)
                starRepos.append(repo)
            }
        }
        return starRepos
    }
    
    func reloadStars() {
        loadStars(token, userName: basicUserInfo.name)
    }
    
    func filterStars(filterText: String) {
        loading = true
        AF.request("https://github.com/stars/\(basicUserInfo.name)/repositories?filter=all&q=\(filterText.trimmingCharacters(in: .whitespacesAndNewlines))", headers: [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36",
        ])
            .responseString { response in
                if let html = response.value {
                    var starred: [StarRepo] = []
                    do {
                        let doc: Document = try SwiftSoup.parse(html)
                        if try doc.select("ul.repo-list").count > 0 {
                            let repoListEl: Element = try doc.select("ul.repo-list").first()!
                            let repoItems: Elements = try repoListEl.select("li.source")
                            for repo: Element in repoItems.array() {
                                let link = try repo.select("a").first()!
                                let url: String = try link.attr("href")
                                let description: String = try repo.select(".py-1 p.d-inline-block").text()
                                
                                let fullName = String(url[String.Index(encodedOffset: 1) ..< String.Index(encodedOffset: url.count)])
                                
                                let stargazersCount: Int = try Int(
                                    repo.select("a.muted-link").first()!.text()
                                        .replacingOccurrences(of: ",", with: "")) ?? 0
                                
                                starred.append(StarRepo(
                                    fullName: fullName,
                                    url: "https://github.com\(url)",
                                    description: description,
                                    stargazersCount: stargazersCount))
                            }
                        }
                        
                    } catch let Exception.Error(_, message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                    self.loading = false
                    
                    let localStars: [StarRepo] = self.filterStarsFromLocalDB(filterText)
                    let concated = localStars + starred
                    var merged: [StarRepo] = []
                    var set: Set<String> = Set<String>()
                    for item in concated {
                        if !set.contains(item.fullName) {
                            merged.append(item)
                            set.insert(item.fullName)
                        }
                    }
                    self.stars = merged
                }
            }
    }
}

struct BasicUserInfo: Hashable {
    let name: String
    let avatarUrl: String
    
    init(name: String, avatarUrl: String) {
        self.name = name
        self.avatarUrl = avatarUrl
    }
}
