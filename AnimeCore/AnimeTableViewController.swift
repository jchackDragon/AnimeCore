


//
//  AnimeTableViewController.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/25/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class AnimeTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "animeCell") as! AnimeCell
        
        return cell
    }
}
