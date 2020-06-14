import Alamofire
import KeychainAccess
import SwiftUI

let TOKEN_KEY = "tagged-github-stars"

class StateStore: ObservableObject {
    let keychain = Keychain(service: "com.github.token")
    
    @Published var token = ""
    @Published var stars: [StarRepo] = []
    @Published var basicUserInfo: BasicUserInfo = BasicUserInfo(name: "", avatarUrl: "")
    
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
    
    func buildAuthHeaders(_ token: String) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)",
        ]
        return headers
    }
    
    func getUserInfo(_ token: String) {
        AF.request("https://api.github.com/user", headers: buildAuthHeaders(token))
            .responseJSON { response in
                if let result = response.value {
                    let user = result as! NSDictionary
                    print("=======", user)
                    self.basicUserInfo = BasicUserInfo(name: user["name"]! as! String, avatarUrl: user["avatar_url"]! as! String)
                    
                    self.loadStars(token)
                }
            }
    }
    
    func loadStars(_ token: String) {
        AF.request("https://api.github.com/users/\(basicUserInfo.name)/starred", headers: buildAuthHeaders(token))
            .responseJSON { response in
                if let links = response.response?.allHeaderFields["Link"] as? String {
                    print("=======link====")
                    print(links)
                    print("=======link====")
                }
                
                if let result = response.value {
                    let stars = result as! NSArray
                    print(stars[0])
                    print("==========")
                    stars.forEach { item in
                        let obj = item as! NSDictionary
                        let fullName = obj["full_name"]! as! String
                        let url = obj["html_url"]! as! String
                        let description = obj.value(forKey: "description") as? String ?? ""
                        let stargazersCount = obj["stargazers_count"]! as! Int
                        
                        self.addStarItem(StarRepo(
                            fullName, url: url,
                            description: description, stargazersCount: stargazersCount))
                    }
                }
            }
    }
}
