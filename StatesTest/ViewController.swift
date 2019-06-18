//
//  ViewController.swift
//  StatesTest
//
//  Created by Paul Vasilenko on 6/18/19.
//  Copyright © 2019 Paul Vasilenko. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, TestServiceProtocol {
    let service = TestService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        service.delegate = self as TestServiceProtocol
        service.getStates()
    }

    
    //MARK: - TestServiceProtocol
    
    func dataReceived() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func errorOccured(error: Error?) {
        print(error as Any)
    }
    
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let keys = service.statesDictionaryKeys else {
            return 0
        }
        
        return keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let key = service.statesDictionaryKeys[indexPath.row]
        
        if let state = service.statesDictionary[key] {
            cell.textLabel?.text = "\(key) - \(state)"
        }
        
        return cell
    }

}

