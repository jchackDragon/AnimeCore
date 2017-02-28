//
//  EpisodeViewController.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/28/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EpisodeViewController: CoreDataTableViewController {
    
    var anime:Anime! {
        didSet{
            self.configureView()
        }
    }
    var currentEpisode:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        //Edit mode ative
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    
    //Adding new Episodes
    @IBAction func addEpisode(_ sender: UIBarButtonItem) {
        if let anime = anime, let fc = self.fetchedResultsController{
           self.currentEpisode += 1
           let newEpisode = Episode(context: fc.managedObjectContext)
           newEpisode.name = anime.name!
           newEpisode.number = Int16(currentEpisode)
           newEpisode.anime = anime
            
        }
        
    }
    // Configure the views in this case the title
    func configureView(){
        if let anime = anime {
            self.navigationItem.title = anime.name
        }
    }
    
    
    //MARK: TableView Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episoceCell")!
        
        let episode = self.fetchedResultsController?.object(at: indexPath) as! Episode
        //cell.textLabel?.text
        cell.textLabel?.text = ("\(episode.number) \(episode.name!)")
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let episode = self.fetchedResultsController?.object(at: indexPath) as! NSManagedObject
            let context = self.fetchedResultsController?.managedObjectContext
            //Removing a episode from database
            context?.delete(episode)
        }
    }
    
}







