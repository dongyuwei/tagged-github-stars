import Foundation
import SQLite

class DBRepoModel {
    var database: Connection!
    let reposTable = Table("repos")
    let id = Expression<Int>("id")
    let fullName = Expression<String>("fullName")
    let url = Expression<String>("url")
    let description = Expression<String>("description")
    let stargazersCount = Expression<Int>("stargazersCount")
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .applicationSupportDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("repos").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print("Database repos initialized at path \(fileUrl)")
            
            createTable()
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createTable = reposTable.create(ifNotExists: true) { table in
            table.column(self.id, primaryKey: true)
            table.column(self.fullName)
            table.column(self.url)
            table.column(self.description)
            table.column(self.stargazersCount)
        }
        
        do {
            try database.run(createTable)
            print("Table repos Created")
            
        } catch {
            print(error)
        }
    }
    
    func insertRepos(_ repos: [StarRepo]) {
        do {
            try database.transaction {
                for (_, item) in repos.enumerated() {
                    try database.run(reposTable.insert(
                        or: OnConflict.ignore, self.fullName <- item.fullName,
                        self.url <- item.url, self.description <- item.description,
                        self.stargazersCount <- item.stargazersCount))
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteRepo(_ repo: StarRepo) {
        let repo = reposTable.select(id, fullName)
            .filter(fullName == repo.fullName)
        
        do {
            try database.run(repo.delete())
        } catch {
            print(error)
        }
    }
    
    func getReposByTagModels(_ tagModels: [TagModel]) -> [StarRepo] {
        var starRepos = [StarRepo]()
        do {
            for (_, item) in tagModels.enumerated() {
                let repos = try database.prepare(
                    reposTable
                        .select(id, fullName, url, description, stargazersCount)
                        .filter(fullName == item.repo)
                        .order(id.asc))
                
                for repo in repos {
                    starRepos.append(StarRepo(
                        fullName: repo[self.fullName],
                        url: repo[self.url],
                        description: repo[self.description],
                        stargazersCount: repo[self.stargazersCount]))
                }
            }
            
        } catch {
            print(error)
        }
        
        return starRepos
    }
}
