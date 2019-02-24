//
//  AppDelegate.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/14.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        let userDefault = UserDefaults.standard
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        
        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            defaultCategoryRegist()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let viewController = CategoryViewController.make()
        let naviCon: UINavigationController = UINavigationController(rootViewController:viewController)
        window?.rootViewController = naviCon
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    
    private func defaultCategoryRegist() {
        let realm = try! Realm()

        try! realm.write {
            let category = CategoryItem()
            category.categoryTitle = "All"
            category.canDeleteFlg = true
            category.priority = true
            
            realm.add(category)
            
//            realm.add(CategoryItem(value: ["categoryTitle": "All"])) //こういう書き方もある
        }
    }


}

