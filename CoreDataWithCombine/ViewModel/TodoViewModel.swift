//
//  TodoViewModel.swift
//  CoreDataWithCombine
//
//  Created by Jonathan Ricky Sandjaja on 11/02/23.
//

import UIKit
import CoreData
import Combine

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchTodoItem() {
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        
        do {
            todos = try context.fetch(request)
        } catch {
            print("Error fetching data. Error: \(error)")
        }
    }
}
