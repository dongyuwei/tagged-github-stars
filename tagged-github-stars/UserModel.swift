import Foundation
import SQLite

class UserModel {
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let token = Expression<String>("token")
    var dataDict = [[String: String]()]
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .applicationSupportDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print("Database initialized at path \(fileUrl)")
            
            createTable()
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createTable = usersTable.create(ifNotExists: true) { table in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.token, unique: true)
        }
        
        do {
            try database.run(createTable)
            print("Table Created")
            
        } catch {
            print(error)
        }
    }
    
    func insertRecord(name: String, token: String) {
        let insertRecord = usersTable.insert(self.name <- name, self.token <- token)
        
        do {
            try database.run(insertRecord)
            print("record added")
        } catch {
            print(error)
        }
    }
    
    func listUsers() -> [HashableUserModel] {
        print("Listed Users")
        var authedUsers = [HashableUserModel]()
        do {
            let users = try database.prepare(usersTable)
            
            for user in users {
                print("User ID: \(user[self.id]), UserName: \(user[self.name]), token: \(user[self.token])")
                
                authedUsers.append(HashableUserModel(id: user[self.id], name: user[self.name], token: user[self.token]))
            }
            
        } catch {
            print(error)
        }
        return authedUsers
    }
    
    func getLatestToken() -> String {
        var latestToken = ""
        do {
            let users = try database.prepare(usersTable)
            
            for user in users {
                latestToken = user[self.token]
            }
            
        } catch {
            print(error)
        }
        return latestToken
    }
}

struct HashableUserModel: Hashable {
    let id: Int
    let name: String
    let token: String
}

struct BasicUserInfo: Hashable {
    let name: String
    let avatarUrl: String
    
    init(name: String, avatarUrl: String) {
        self.name = name
        self.avatarUrl = avatarUrl
    }
}
