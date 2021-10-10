//
//  MessageCell.swift
//  myTodo
//
//  Created by Toshiyana on 2021/07/30.
//

import UIKit
import SwipeCellKit

class MessageCell: SwipeTableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    // @IBOutlet weak var timesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
