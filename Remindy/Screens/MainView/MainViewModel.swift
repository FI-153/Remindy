//
//  MainViewModel.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 26/04/22.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {

    private let persistanceManager: PersistanceManager
    private let containerContext: NSManagedObjectContext

    @Published var fetchedItems: [Item] = []
    @Published var newItemName: String = .empty

    var cacellables = Set<AnyCancellable>()

    init() {
        self.persistanceManager = PersistanceManager.shared
        self.containerContext = persistanceManager.containerContext

        subscribeToFetchedObjects()
    }

    func saveModifications() {
        persistanceManager.saveData()
    }

    func subscribeToFetchedObjects() {
        persistanceManager.$fetchedItems.sink { [weak self] items in
            guard let self = self else { return }

            self.fetchedItems = items
        }
        .store(in: &cacellables)
    }

    func addItem(named name: String) {

        if !name.isEmpty {
            persistanceManager.createItem(named: name)
            saveModifications()
        }
    }

    /// Deletes an item at a given indexSet
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }

        let item = fetchedItems[index]
        containerContext.delete(item)

        saveModifications()
    }

    /// Deletes all the items
    func clearFetchedItems() {
        for item in fetchedItems {
            containerContext.delete(item)
        }

        saveModifications()
    }

    func clerTypedText() {
        newItemName = .empty
    }

}
