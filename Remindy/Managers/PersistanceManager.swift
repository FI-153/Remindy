//
//  PersistanceManager.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 26/04/22.
//

import Foundation
import CoreData

class PersistanceManager {

    /// Shared instance of PersistanceManager
    static let shared = PersistanceManager()

    let container: NSPersistentContainer
    var containerContext: NSManagedObjectContext {
        container.viewContext
    }

    /// Child context of the main context, to be used for the example item in the SettingsView
    var childContext: NSManagedObjectContext {
        NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }

    private let dateEngine = DateEngine()

    /// Contains all the saved items
    /// Refreshed every time the saveData function is called
    @Published var fetchedItems: [Item] = []

    private init() {
        container = NSPersistentContainer(name: "Remindy")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Failed loading DB")
            }
        }

        fetchedItems = fetchItems(named: "Item")
    }

    /// Gets the shared instance of PersistanceManager
    static func getShared() -> PersistanceManager {
        shared
    }

    func saveData() {
        do {
            try containerContext.save()
            refreshFetchedItems()
        } catch {
            print("Not able to save: \(error)")
        }
    }

    private func fetchItems<T: NSManagedObject>(named: String) -> [T] {
        let request = NSFetchRequest<T>(entityName: named)
        var fetchedItems: [T] = []

        do {
            fetchedItems = try containerContext.fetch(request)
        } catch {
            print("Error fetching: \(error)")
        }

        return fetchedItems
    }

    func createItem(named phrase: String) {
        let newItem = Item(context: containerContext)
        newItem.id = UUID()
        newItem.name = phrase.uppercaseFirstLetter()
        newItem.isRemindable = dateEngine.isRemindable(phrase)
        newItem.isReminded = false
    }

    /// Deletes an item passed by reference
    func delete(_ item: Item) {
        containerContext.delete(item)
        saveData()
    }

    func deleteAllSavedItems() {
        for item in fetchedItems {
            containerContext.delete(item)
        }

        saveData()
    }

    func toggleIsReminded(for item: Item) {
        containerContext.performAndWait {
            item.isReminded.toggle()
            saveData()
        }
    }

    private func refreshFetchedItems() {
        fetchedItems = fetchItems(named: "Item")
    }

}
