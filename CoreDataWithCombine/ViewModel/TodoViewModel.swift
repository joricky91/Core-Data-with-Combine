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
    
    func addNewData(task: String) {
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.task = task
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func deleteSelectedData(indexPath: IndexPath) {
        let selectedItems = todos[indexPath.row]
        context.delete(selectedItems)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        fetchTodoItem()
    }
}
