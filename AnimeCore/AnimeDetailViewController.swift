//
//  AnimeDetailViewController.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/28/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AnimeDetailViewController:UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var viewContext:NSManagedObjectContext!
    
    var anime:Anime! {
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        if let anime = anime{
            // Show the anmie name in navition item title
            self.navigationItem.title = anime.name
            
            //Set the anime description
            if let description = self.descriptionTextView{
                description.text = anime.animeDescription
            }
            //Set the image poster
            if let imageData = anime.poster, let posterImage = posterImage{
                let data = imageData.imageData as! Data
                posterImage.image = UIImage(data:data)
                
            }
   
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "animeEpisodeSegue"{
            
            if let episodeController = segue.destination as? EpisodeViewController {
               
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Episode.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
                // TODO: ADD THE FILTER PREDICATE
                let predicate = NSPredicate(format: "anime = %@", argumentArray: [self.anime])
                fetchRequest.predicate = predicate
                
                let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
                
                 episodeController.anime = self.anime
                 episodeController.fetchedResultsController = fetchedResultsController
            }
        }
        
    }
}
