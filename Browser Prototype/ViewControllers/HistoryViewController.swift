//
//  HistoryViewController.swift
//  Browser Prototype
//
//  Created by Marius Malyshev on 11.06.2023.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var delegate: HistoryURLSelectionDelegate!
    private var history = [String]()
    
    func setupViewControllerWith(_ history: [String]) {
        self.history = history.reversed()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.historyCell)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.historyCell, for: indexPath)
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: history[indexPath.row]) else { return }
        delegate.openURLFromHistoryVC(url)
        dismiss(animated: true)
    }
}
