//
//  CoreStack.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/26/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import CoreData

class CoreStack {
    let model:String!
    
    //MARK: initializer
    
    init(model:String){
        self.model = model
    }

    //MARK: Core data Stack
    
    lazy var container:NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: self.model)
        //Merge the changes tha take place in backgroun context
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores(completionHandler: { (persistentDescription, error) in
            
            if let error = error as NSError?{
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}

//MARK: CoreStack (Batch processing in the background)
extension CoreStack {
    
    func processingInBackGround(_ batch: @escaping (NSManagedObjectContext) -> ()){
    
        self.container.performBackgroundTask { (context) in
   
          batch(context)
            
            do{
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("processingInBackGround: \(error), \(error.userInfo)")
            }
        }
    }
}


//MARK: Saving support

extension CoreStack {

    func saveContext(){
        let context = self.container.viewContext
        
        if context.hasChanges {
            do{
              try context.save()
            }catch let error as NSError{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func autoSave(delayInSecond:Int){
    
        if delayInSecond > 0 {
            saveContext()
            
            let delayInNanoSecond = UInt64(delayInSecond) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(UInt64(delayInNanoSecond)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.autoSave(delayInSecond: delayInSecond)
            }
        }
    }
}

