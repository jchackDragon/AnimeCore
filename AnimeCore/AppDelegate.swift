//
//  AppDelegate.swift
//  AnimeCore
//
//  Created by Juan Carlos Lopez on 2/24/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreStack = CoreStack(model: "Model")

    
    func loadDumiData() {
        coreStack.processingInBackGround { (context) in
            /* Path for JSON files bundled in the project */
            let dumiDataPath = Bundle.main.path(forResource: "dumidata", ofType: "json")
            
            guard (dumiDataPath != nil) else {
                print("Cannot find the file")
                return
            }
            
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: dumiDataPath!)) else{
                print("Dumi data error")
                return
            }
            
            let parsedResult:AnyObject!
            // parse data to readable object
            do{
                parsedResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }catch{
                //let error = error as! NSError
                fatalError("Error will parsing the data to json, data:\(data)")//\(error.userInfo)")
                return
            }

            //get the list of anime
            guard (parsedResult != nil), let animeList = parsedResult["anime"] as? [[String:AnyObject]] else{
                print("Cannot find the key 'anime' in \(parsedResult)")
                return
            }
            
            //create animes object into the background context
            for animeInfo in animeList{
                let newAnime = Anime(context: context)
                newAnime.name = animeInfo["name"] as! String
                newAnime.animeDescription = animeInfo["description"] as! String
                newAnime.rating = animeInfo["rating"] as! Float
                newAnime.imageUrl = animeInfo["imageurl"] as! String
            }
            
            print("Finish loading dumi data")
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationController = window!.rootViewController as! UINavigationController
        let animeTable = navigationController.topViewController as! AnimeTableViewController
        
        animeTable.viewContext = coreStack.container.viewContext
        
        self.coreStack.autoSave(delayInSecond: 60)
        
        if (UserDefaults.standard.value(forKey: "AppLunchedBefore") == nil) {
            UserDefaults.standard.set(true, forKey: "AppLunchedBefore")
            UserDefaults.standard.synchronize()
            loadDumiData()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.coreStack.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.coreStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

