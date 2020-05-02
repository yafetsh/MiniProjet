//
//  AppDelegate.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import CoreData
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "955123888565-fdl2eh5lj4bcqkbhv558l385j3g9hmvm.apps.googleusercontent.com"
        GMSPlacesClient.provideAPIKey("AIzaSyCzbFakqn_dLf07tgtll7pg6JAIWGqX2vk")
        
        // Customize the UI of GMSAutocompleteViewController
        // Set some colors (colorLiteral is convenient)
        let barColor: UIColor =  _ColorLiteralType(red: 0, green: 0.2, blue: 0.4196078479, alpha: 1)
        let backgroundColor: UIColor =  _ColorLiteralType(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let textColor: UIColor =  _ColorLiteralType(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        // Navigation bar background.
          UINavigationBar.appearance().barTintColor = barColor
          UINavigationBar.appearance().tintColor = UIColor.white
        // Color and font of typed text in the search bar.
          let searchBarTextAttributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 16)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes as [NSAttributedString.Key : Any]
        // Color of the placeholder text in the search bar prior to text entry
          let placeholderAttributes = [NSAttributedString.Key.foregroundColor: backgroundColor, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)]
        // Color of the default search text.
          let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes as [NSAttributedString.Key : Any])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ProjetIOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

