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
        
        firstLunchSetting()
        lunchCountUp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let viewController = CategoryViewController.make()
        let naviCon: UINavigationController = UINavigationController(rootViewController:viewController)
        window?.rootViewController = naviCon
        window?.makeKeyAndVisible()
        
        let config = Realm.Configuration(
            schemaVersion: 2,
            
            //スキーマのバージョンが上記のものよりも低い/を開くときに自動的に呼び出されるブロックを設定する
            migrationBlock: { migration, oldSchemaVersion in
                //まだ何も移行していないので、oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Realmは新しいプロパティと削除されたプロパティを自動的に検出します
                    //そして自動的にディスク上のスキーマを更新する
                }})
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    private func firstLunchSetting() {
        let userDefault = UserDefaults.standard
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        
        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            defaultCategoryRegist()
        }
    }
    
    private func lunchCountUp() {
        let userDefault = UserDefaults.standard
        if !userDefault.bool(forKey: "lunchCount") {
            let userDefault = UserDefaults.standard
            let dict = ["lunchCount": 0]
            userDefault.register(defaults: dict)
            
            let dict2 = ["shown": false]
            userDefault.register(defaults: dict2)
        }

        // 表示済みだったらカウントしない
        if userDefault.bool(forKey: "shown") {
            return
        }
        var count = userDefault.integer(forKey: "lunchCount")
        count = count + 1
        userDefault.set(count, forKey: "lunchCount")
    }
    
    private func defaultCategoryRegist() {
        let realm = try! Realm()

        try! realm.write {
            let category = CategoryItem()
            category.categoryTitle = "All tasks"
            category.canDeleteFlg = true
            category.priority = 3
            
            realm.add(category)
        }
    }
}

