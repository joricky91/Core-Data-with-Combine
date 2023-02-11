//
//  ViewController.swift
//  CoreDataWithCombine
//
//  Created by Jonathan Ricky Sandjaja on 11/02/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var viewModel: TodoViewModel = TodoViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupConstraints()
        viewModel.fetchTodoItem()
        setupBindings()
    }

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    func setupBindings() {
        viewModel.$todos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
        ])
    }
    
    @objc func tapAddButton() {
        let alert = UIAlertController(title: "Add Task", message: "Enter your new task", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter task..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    self.viewModel.addNewData(task: text)
                    self.viewModel.fetchTodoItem()
                }
            }
        }))
        
        present(alert, animated: true)
        
    }

}

