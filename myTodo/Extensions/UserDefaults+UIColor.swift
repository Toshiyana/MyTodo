//
//  UserDefaults+UIColor.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import UIKit

extension UserDefaults {
    func saveColor(color: UIColor?, key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error saving Color by UserDefaults.")
            }
        }
        set(colorData, forKey: key)
    }
    
    func getColorForKey(key: String) -> UIColor? {
        var colorReturned: UIColor?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    colorReturned = color
                }
            } catch {
                print("Error getting Color by UserDefaults.")
            }
        }
        return colorReturned
    }
}
