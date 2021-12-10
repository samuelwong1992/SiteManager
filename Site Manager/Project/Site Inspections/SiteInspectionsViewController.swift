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
        return project.siteInspectionsArray
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
        tableView.register(NewSiteInspectionTableViewCell.kNib, forCellReuseIdentifier: NewSiteInspectionTableViewCell.kReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: Table View Delegate and Data Source
extension SiteInspectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteInspections.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSiteInspectionTableViewCell.kReuseIdentifier) as! NewSiteInspectionTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SiteInspectionTableViewCell.kReuseIdentifier) as! SiteInspectionTableViewCell
            cell.siteInspection = siteInspections[indexPath.row-1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let vc = SiteInspectionInitializationViewController.viewController {
                vc.project = project
                self.present(vc, animated: true, completion: nil)
            }
        default:
            if let vc = SiteInspectionNavigationController.navigationController {
                vc.siteInspection = siteInspections[indexPath.row-1]
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
