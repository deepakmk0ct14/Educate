//
//  EventsCreateViewController.swift
//  Educate
//
//  Created by Deepak on 4/5/20.
//  Copyright © 2020 Deepak. All rights reserved.
//

import UIKit

class EventsCreateViewController: UIViewController, AuthRouter {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var schoolButton: UIButton!
    var school: School?
    let mviewModel = EventsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSchoolButton(_ sender: Any) {
        onSchoolsScreen { (_school) in
            self.school = _school
            self.schoolButton.setTitle(self.school?.name, for: .normal)
        }
    }
    @IBAction func onDoneButton(_ sender: Any) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MonDDYY"
           let dateValue =  dateFormatter.string(from: datePicker.date)
        let event = Event(id: "", name: eventName.text, description: eventDescription.text, date: dateValue, schoolId: school?.id , schoolName: school?.name)
        mviewModel.createEventWithEventDetails(event: event) { (isSuccess) in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
