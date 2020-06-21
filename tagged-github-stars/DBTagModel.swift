import Foundation
import SQLite

class DBTagModel {
    var database: Connection!
    let tagsTable = Table("tags")
    let id = Expression<Int>("id")
    let tag = Expression<String>("tag")
    let repo = Expression<String>("repo")
    
    init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .applicationSupportDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("tags").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print("Database tags initialized at path \(fileUrl)")
            
            createTable()
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createTable = tagsTable.create(ifNotExists: true) { table in
            table.column(self.id, primaryKey: true)
            table.column(self.repo)
            table.column(self.tag)
        }
        
        do {
            try database.run(createTable)
            print("Table tags Created")
            
        } catch {
            print(error)
        }
    }
    
    func insertTags(_ tags: [String], repo: String) {
        do {
            try database.transaction {
                for (_, tag) in tags.enumerated() {
                    if(tag != "") {
                        print("insert tag: ", tag, repo)
                        try database.run(tagsTable.insert(or: OnConflict.ignore, self.repo <- repo, self.tag <- tag))
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteTag(tag: String, repo: String) {
        let tag = tagsTable.select(self.id, self.repo, self.tag)
        .filter(self.repo == repo && self.tag == tag)
        
        do {
            try database.run(tag.delete())
        } catch {
            print(error)
        }
        
    }
    
    func getTagModels(_ repoName: String) ->  [TagModel]{
        var tagsOfRepo = [TagModel]()
        do {
            let tags = try database.prepare(tagsTable.select(self.id, self.repo, self.tag).filter(self.repo == repoName).order(self.id.asc))
            
            for tag in tags {
                tagsOfRepo.append(TagModel(id: tag[self.id], repo: tag[self.repo], tag: tag[self.tag]))
            }
            
        } catch {
            print(error)
        }
        print("get tags", tagsOfRepo)
        return tagsOfRepo
    }
    
    func getTagModelsByTag(_ tag: String) ->  [TagModel]{
        print("get tags")
        var tagsOfRepo = [TagModel]()
        do {
            let tags = try database.prepare(tagsTable.select(self.id, self.repo, self.tag).filter(self.tag == tag).order(self.id.asc))
            
            for tag in tags {
                tagsOfRepo.append(TagModel(id: tag[self.id], repo: tag[self.repo], tag: tag[self.tag]))
            }
            
        } catch {
            print(error)
        }
        
        return tagsOfRepo
    }

}

struct TagModel: Identifiable, Hashable {
    let id: Int
    let repo: String
    let tag: String
    
    static func == (lhs: TagModel, rhs: TagModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
