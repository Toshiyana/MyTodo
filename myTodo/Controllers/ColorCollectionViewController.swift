//
//  ColorCollectionViewController.swift
//  myTodo
//
//  Created by Toshiyana on 2021/05/20.
//

import UIKit
import ChameleonFramework

private let reuseIdentifier = "Cell"

class ColorCollectionViewController: UICollectionViewController {

    let defaults = UserDefaults.standard
    
    let colors: [UIColor] = [FlatBlue(), FlatRed(), FlatOrange(), FlatYellow(), FlatSand(), FlatNavyBlue(), FlatBlack(), FlatMagenta(), FlatTeal(), FlatSkyBlue(), FlatGreen(), FlatMint(), FlatWhite(), FlatGray(), FlatForestGreen(), FlatPurple(), FlatBrown(), FlatPlum(), FlatWatermelon(), FlatLime(), FlatPink(), FlatMaroon(), FlatCoffee(), FlatPowderBlue()]
    
    let colorNames: [String] = ["Blue", "Red", "Orange", "Yellow", "Sand", "NavyBlue", "Black", "Magenta", "Teal", "SkyBlue", "Green", "Mint", "White", "Gray", "ForestGreen", "Purple", "Brown", "Plum", "Watermelon", "Lime", "Pink", "Maroon", "Coffee", "PowderBlue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.colorCollectionCellIdentifier, for: indexPath) as! ColorCollectionViewCell

        cell.color.backgroundColor = colors[indexPath.row]
        cell.name.text = colorNames[indexPath.row]
        
        return cell
    }
    
//    // celltap時の処理(ボタンの場合，これいらない？？)
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedColor = colorNames[indexPath.row]
//        print(selectedColor)
//
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! CollectionViewCell
////
////        // cell枠の太さ
////        cell.layer.borderWidth = 1.0
////        // cell枠の色
////        cell.layer.borderColor = UIColor.black.cgColor
////        // cellを丸くする
////        cell.layer.cornerRadius = 12.0
////        collectionView.reloadData()
//    }
    
    //MARK: - Color Setting Methods
    func saveNavColor(color: UIColor) {
        defaults.saveColor(color: color, key: "NavBarColor")
    }
    
    //MARK: - ColorButton Methods
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        let selectedColor = sender.backgroundColor
        defaults.saveColor(color: selectedColor, key: "NavBarColor")
        
        // navBatの色をリロードするには，navBar.barTintColorに再度アクセスすれば良い
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
    }


}
