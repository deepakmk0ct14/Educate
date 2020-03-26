//
//  SchoolsViewController.swift
//  Educate
//
//   3/26/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController, Storyboarding {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mLoadingLabel: UILabel!
    let mViewModel = AuthViewModel()
    var dataSource = [School]() {
        didSet {
            mTableView.isHidden = dataSource.count <= 0
            mLoadingLabel.isHidden = !mTableView.isHidden
        }
    }
    var onSelectedSchool: ((School)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        mViewModel.getSchoolsList { (schools) in
            self.dataSource = schools
            self.mTableView.reloadData()
        }
    }
}

extension SchoolsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolCells", for: indexPath)
        if let schoolCell = cell as? SchoolTableViewCell{
          let model = dataSource[indexPath.row]
            schoolCell.setCellDetails(school: model)
            return schoolCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        dismiss(animated: true) {
            self.onSelectedSchool?(model)
        }
    }
}
