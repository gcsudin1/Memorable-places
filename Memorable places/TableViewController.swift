//
//  TableViewController.swift
//  Memorable places
//
//  Created by IMCS2 on 8/10/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class TableViewController: UITableViewController {
    var displayArray = [MKPointAnnotation] ()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "tabletomain",
            let destination = segue.destination as? ViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.recieveData =  displayArray[cellIndex]
            destination.flag = 1
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = displayArray[indexPath.row].title
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
