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
    
    func getFavoritesList() -> OpenBookList {
        let bookList: NSFetchRequest<OpenBookList> = OpenBookList.fetchRequest()
        if let results = try? managedContext.fetch(bookList),
           let list = results.first(where: { $0.title == "favorites" }) {
            return list
        }
        let favoritesList = OpenBookList(context: managedContext)
        favoritesList.setValue("favorites", forKey: #keyPath(OpenBookList.title))
        saveContext()
        return favoritesList
    }
}
