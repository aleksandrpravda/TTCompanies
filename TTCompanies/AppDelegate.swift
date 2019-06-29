//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            self.navigationController = UINavigationController()
            window.backgroundColor = UIColor.white
            window.rootViewController = self.navigationController
            window.makeKeyAndVisible()
            self.navigationController = UINavigationController()
            self.window?.rootViewController = self.navigationController
            let viewController = ViewController(databaseService: CoreDataService(persistentContainer: self.persistentContainer, webService: CompaniesWebService()))
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        return true
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TTCompanies")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
}

