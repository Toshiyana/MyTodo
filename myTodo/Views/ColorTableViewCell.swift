//
//  ColorTableViewCell.swift
//  myTodo
//
//  Created by Toshiyana on 2021/05/20.
//

import UIKit
import ChameleonFramework

class ColorTableViewCell: UITableViewCell {
    
    let defaults = UserDefaults.standard
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let colorView: UIView = {
        let view = UIView()
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(colorView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(x: 25 + iconContainer.frame.size.width, y: 0, width: contentView.frame.size.width - 20 - iconContainer.frame.size.width, height: contentView.frame.size.height)
        
        colorView.frame = CGRect(x: contentView.frame.size.width - 45, y: contentView.center.y - 16, width: size, height: size)
        
        colorView.layer.cornerRadius = colorView.frame.size.width / 2
    }
    
    public func configure(with model: SettingColorOption) {
        label.text = model.title
        iconImageView.image = model.icon
        //modelからcolorを取得すると、なぜかテーマカラー選択後に設定画面に戻ってもcolorViewの色が更新されない（tableView.reload()しても）
        //対して、ColorTableViewCellでdefaultsから色を読み込んで、設定画面でtableView.reload()をしたら色が更新されたのでそれでやった
        //できれば、再利用可能度を高めるために、defaultsをこのファイルに入れたくなかった
        colorView.backgroundColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
    }
    
}
