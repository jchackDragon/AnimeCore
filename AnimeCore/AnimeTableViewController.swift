


//
//  AnimeTableViewController.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/25/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AnimeTableViewController: CoreDataTableViewController {
    
    var viewContext:NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Anime.fetchRequest()
        
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: false), NSSortDescriptor(key:"rating", ascending: false)]
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        fetchRequest.fetchBatchSize = 20
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "animeCellSegue" {
           
            if let animeDetailController = segue.destination as? AnimeDetailViewController{
              
                //get indexPath for selected row
                let indexPath = self.tableView.indexPathForSelectedRow
                //get selected anime from fetchedResultController
                let anime = self.fetchedResultsController?.object(at: indexPath!)
                //set anime property
                animeDetailController.anime = anime as! Anime
                animeDetailController.viewContext = self.viewContext
                
            }
        }
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "animeCell") as! AnimeCell
        
        let anime = self.fetchedResultsController?.object(at: indexPath) as! Anime
        
        cell.animeName.text = anime.name
        cell.animeDescription.text = anime.animeDescription
        
        if (anime.poster == nil){
        //get poster image form web
            self.getDataWith(urlString: anime.imageUrl!) { (data) in
                let poster  = Poster(context: self.viewContext)
                poster.imageData = data as NSData?
                poster.anime = anime
            
                cell.animeImage.image = UIImage(data: data)!
            }
        }else{
            let data = anime.poster!.imageData as! Data
            cell.animeImage.image = UIImage(data: data)!
        }
        
        return cell
    }
    
    
    func getDataWith(urlString: String, completionHandler: @escaping (_ data:Data)->Void){
        
        let url = URL(string:urlString)
        
        if let url = url{
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                func showError(_ error:String){
                    print(error)
                }
                
                guard (error == nil) else{
                    showError(error!.localizedDescription)
                    return
                }
                
                guard let stat = (response as? HTTPURLResponse)?.statusCode, stat >= 200 && stat <= 299 else{
                    showError("The request returned status code other than 2xx")
                    return
                }
                
                guard let data = data else{
                    showError("There was an eror no data returned")
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler(data)
                }
                
                
            }.resume()
        }
    }
}




