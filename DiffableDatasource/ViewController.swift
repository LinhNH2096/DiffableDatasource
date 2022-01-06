//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by Nguyễn Hồng Lĩnh on 24/12/2021.
//

import UIKit

// MARK: Model
enum Section {
    case first
}

struct Item: Hashable {
    var title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

// MARK: ViewController
class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var datasource: UITableViewDiffableDataSource<Section, Item>!
    
    private var items = Set<Item>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ViewController: UITableViewDelegate {
    
    func setup() {
        title = "Diffable Datasource"
        // Table View
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.frame = view.bounds
        
        datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.title
            return cell
        })
        
        // Plus Bar Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapPlusButton))
    }
    
    @objc func didTapPlusButton() {
        let actionSheet = UIAlertController(title: "Select Item", message: nil, preferredStyle: .actionSheet)
        for i in 1...100 {
            actionSheet.addAction(UIAlertAction(title: "Item \(i)", style: .default, handler: { [unowned self] _ in
                let item = Item(title: "Item \(i)")
                self.items.insert(item)
                self.updateDatasource()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.first])
        snapshot.appendItems(Array(self.items).sorted(by: { $0.title < $1.title }))
        datasource.apply(snapshot)
    }
}



