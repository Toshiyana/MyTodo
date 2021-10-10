//
//  SettingViewController.swift
//  myTodo
//
//  Created by Toshiyana on 2021/04/14.
//

import UIKit
import ChameleonFramework

struct Section {
    let title: String
    let options: [SettingOptionType]
}

enum SettingOptionType {
    case staticCell(model: SettingOption)
    case settingIconCell(model: SettingIconOption)
    case colorCell(model: SettingColorOption)
    case versionCell(model: SettingVersionOption)
}

struct SettingOption {
    let title: String
    let handler: (() -> Void)
}

struct SettingIconOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

struct SettingColorOption {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

struct SettingVersionOption {
    let title: String
    let icon: UIImage?
    let detailText: String
}

class SettingViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    var models = [Section]()
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        title = "Setting"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Setting.staticCellIdentifier)
        tableView.register(SettingIconTableViewCell.self, forCellReuseIdentifier: K.Setting.settingIconCellIdentifier)
        tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: K.Setting.colorCellIdentifier)
        tableView.register(VersionTableViewCell.self, forCellReuseIdentifier: K.Setting.versionCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist.")
        }
        
        navBar.barTintColor = defaults.getColorForKey(key: "NavBarColor") ?? FlatBlue()
        tableView.reloadData()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func configure() {
        models.append(Section(title: "ユーザー設定", options: [
            //通知メッセージ（指定の名言、ランダム）の項目は後回しにして、とりあえずランダムのみ
            .settingIconCell(model: SettingIconOption(
                                title: "通知時刻",
                                icon: UIImage(systemName: "clock")) {
                                    //
                                }),
            .colorCell(model: SettingColorOption(
                        title: "テーマカラーの変更",
                        icon: UIImage(systemName: "paintpalette")
                        ) {
                self.performSegue(withIdentifier: K.settingToColorSegue, sender: self)
            })
        ]))
        
        models.append(Section(title: "アプリについて", options: [
            //通知メッセージ（指定の名言、ランダム）の項目は後回しにして、とりあえずランダムのみ
            .settingIconCell(model: SettingIconOption(
                                title: "アプリの使い方",
                                icon: UIImage(systemName: "text.book.closed")) {
                                    //
                                }),
            .settingIconCell(model: SettingIconOption(
                                title: "不具合を報告",
                                icon: UIImage(systemName: "exclamationmark.triangle")) {
                                    //
                                }),
            .settingIconCell(model: SettingIconOption(
                                title: "アプリを評価",
                                icon: UIImage(systemName: "star")) {
                                    //
                                }),
        ]))
        
        

        models.append(Section(title: "その他", options: [
            //通知メッセージ（指定の名言、ランダム）の項目は後回しにして、とりあえずランダムのみ
            .settingIconCell(model: SettingIconOption(
                                title: "データの削除",
                                icon: UIImage(systemName: "trash")) {
                                    //
                                }),
            .versionCell(model: SettingVersionOption(
                            title: "バージョン",
                            icon: UIImage(systemName: "info.circle"),
                            detailText: version))
        ]))
        
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.staticCellIdentifier,
                for: indexPath)
            cell.textLabel?.text = model.title
            cell.accessoryType = .disclosureIndicator
            return cell

        case .settingIconCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.settingIconCellIdentifier,
                    for: indexPath
            ) as? SettingIconTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        
        case .colorCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.colorCellIdentifier,
                    for: indexPath
            ) as? ColorTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .versionCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Setting.versionCellIdentifier,
                    for: indexPath
            ) as? VersionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // action when cell was tapped
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .settingIconCell(let model):
            model.handler()
        case .colorCell(let model):
            model.handler()
        default://case .versionCell
            return
        }
    }
        
}
