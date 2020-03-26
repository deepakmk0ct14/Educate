//
//  SchoolTableViewCell.swift
//  Educate
//
//   3/26/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var mSchoolNameLabel: UILabel!
    @IBOutlet weak var mAdressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellDetails(school:School) {
        mSchoolNameLabel.text = school.name
        mAdressLabel.text = school.address
    }
}
