//
//  DashboardViewController.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit
import Firebase
class EventsViewController: UIViewController, AuthRouter, Storyboarding {

    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    
    @IBOutlet weak var mLoadingLabel: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    let mAuthViewModel = AuthViewModel()
    let mviewModel = EventsViewModel()
    var dataSource = [Event]() {
        didSet {
            mTableView.isHidden = dataSource.count <= 0
            mLoadingLabel.isHidden = !mTableView.isHidden
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        realTimeData()
        mviewModel.getEvents { (events) in
            self.dataSource = events
            self.mTableView.reloadData()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        mAuthViewModel.onLogOut { (isSuccess) in
            self.onLogout()
        }
    }
    
    func realTimeData() {
        let db = Firestore.firestore()
        db.collection("Events")
            .addSnapshotListener { querySnapshot, error in
                guard  error == nil, let documents = querySnapshot?.documents else  {
                    return
                }
                _ = documents.map({ (document)  in
                    let docData =  document.data()
                    let name = docData["Name"] as? String
                    print(" Doc Data real Time \(name ?? "")" )
                })
        }
        
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView .dequeueReusableCell(withIdentifier: "EventTablViewCell", for: indexPath)
        cell.selectionStyle = .none
        if let eventCell = cell as? EventTablViewCell{
          let model = dataSource[indexPath.row]
            eventCell.setEventDetails(event: model)
            return eventCell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

