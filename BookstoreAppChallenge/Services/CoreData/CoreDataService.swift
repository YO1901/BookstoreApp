//
//  CoreDataService.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 11.12.2023.
//

import CoreData

class CoreDataService {
    private let modelName: String
    
    static let shared = CoreDataService(modelName: "BookstoreDataModel")

    private init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func getRecentList() -> OpenBookList {
        getListWithCreataion("Recent")
    }
    
    func getLikesList() -> OpenBookList {
        getListWithCreataion("Likes")
    }
    
    func getLists() -> [OpenBookList] {
        let bookList: NSFetchRequest<OpenBookList> = OpenBookList.fetchRequest()
        return (try? managedContext.fetch(bookList)) ?? []
    }
    
    @discardableResult
    func createNewList(title: String) -> Bool {
        guard !getLists().map({ $0.title }).contains(title) else {
            return false
        }
        let newList = OpenBookList(context: managedContext)
        newList.setValue(title, forKey: #keyPath(OpenBookList.title))
        saveContext()
        return true
    }
    
    @discardableResult
    func deleteList(title: String) -> Bool {
        guard let list = getLists().first(where: { $0.title == title }) else {
            return false
        }
        managedContext.delete(list)
        return true
    }
    
    private func getListWithCreataion(_ title: String) -> OpenBookList {
        let bookList: NSFetchRequest<OpenBookList> = OpenBookList.fetchRequest()
        if let results = try? managedContext.fetch(bookList),
           let list = results.first(where: { $0.title == title }) {
            return list
        }
        let favoritesList = OpenBookList(context: managedContext)
        favoritesList.setValue(title, forKey: #keyPath(OpenBookList.title))
        saveContext()
        return favoritesList
    }
}
