//
//  AppDelegate.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        
        do {
            //let realm = try Realm()
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)//realmのdataが保存されているファイルまでのpath
        
        return true
    }

}
