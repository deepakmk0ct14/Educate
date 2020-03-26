//
//  EventCollectionViewCell.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class EventTablViewCell: UITableViewCell {
  
    @IBOutlet weak var mEventName: UILabel!
    @IBOutlet weak var mEventDescription: UILabel!
    @IBOutlet weak var mEventDate: UILabel!
    @IBOutlet weak var mSchoolName: UILabel!
    
    func setEventDetails(event: Event) {
        mEventName.text = event.name
        mEventDescription.text = event.description
        mEventDate.text = event.date
        mSchoolName.text = event.schoolName
    }
}
