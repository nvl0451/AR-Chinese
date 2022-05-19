//
//  InfoCell.swift
//  rtc_phone
//
//  Created by Андрей Королев on 12.05.2022.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var chineseText: UILabel!
    @IBOutlet weak var englishText: UILabel!
    @IBOutlet weak var tagText: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
