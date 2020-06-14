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
    
    func insertRecord(tag: String, repo: String) {
        let insertRecord = tagsTable.insert(self.repo <- repo, self.tag <- tag)
        
        do {
            try database.run(insertRecord)
            print("record added")
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
    
    func getTags(_ repoName: String) ->  [TagModel]{
        print("get tags")
        var tagsOfRepo = [TagModel]()
        do {
            let tags = try database.prepare(tagsTable.select(self.id, self.repo, self.tag).filter(self.repo == repoName))
            
            for tag in tags {
                print("Tag ID: \(tag[self.id]), repo: \(tag[self.repo]), tag: \(tag[self.tag])")
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
