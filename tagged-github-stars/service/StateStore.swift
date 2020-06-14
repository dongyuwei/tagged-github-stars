import Alamofire
import SwiftUI

class StateStore: ObservableObject {
    @Published var token = ""
    @Published var stars: [StarRepo] = []
    @Published var basicUserInfo: BasicUserInfo = BasicUserInfo(name: "", avatarUrl: "")
    
    func setToken(_ token:String){
        self.token = token;
    }
    
    func addStarItem(_ item: StarRepo) {
        stars.append(item)
    }
    
    func getStoredToken() -> String {
        let userModel = UserModel()
        return userModel.getLatestToken()
    }
    
    func buildAuthHeaders(_ token: String) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)",
        ]
        return headers
    }
    
    func getUserInfo() {
        AF.request("https://api.github.com/user", headers: buildAuthHeaders(self.token))
            .responseJSON { response in
                if let result = response.value {
                    let user = result as! NSDictionary
                    print("=======", user)
                    self.basicUserInfo = BasicUserInfo(name: user["name"]! as! String, avatarUrl: user["avatar_url"]! as! String)
                }
            }
    }
    
    func loadStars() {
        AF.request("https://api.github.com/users/dongyuwei/starred", headers: buildAuthHeaders(self.token))
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
