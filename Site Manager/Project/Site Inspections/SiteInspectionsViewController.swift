//
//  SiteInspectionsViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class SiteInspectionsViewController: ProjectBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var siteInspections: [SiteInspection] {
        return User.currentUser.siteInspections.filter({ $0.project.id == project.id})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionsViewController {
    func initialize() {
        tableView.register(SiteInspectionTableViewCell.kNib, forCellReuseIdentifier: SiteInspectionTableViewCell.kReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: Table View Delegate and Data Source
extension SiteInspectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteInspections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteInspectionTableViewCell.kReuseIdentifier) as! SiteInspectionTableViewCell
        
        cell.siteInspection = siteInspections[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = SiteInspectionNavigationController.navigationController {
            vc.siteInspection = siteInspections[indexPath.row]
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
