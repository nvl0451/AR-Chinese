//
//  StringCell.swift
//  rtc_phone
//
//  Created by Андрей Королев on 06.05.2022.
//

import UIKit

class StringCell: UITableViewCell {

    
    @IBOutlet weak var stringLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
