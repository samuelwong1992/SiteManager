//
//  ProjectsViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension ProjectsViewController {
    func initialize() {
        tableView.register(ProjectTableViewCell.kNib, forCellReuseIdentifier: ProjectTableViewCell.kReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: Table View Delegate and Data Source
extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.currentUser.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.kReuseIdentifier) as! ProjectTableViewCell
        
        cell.project = User.currentUser.projects[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navController = ProjectNavigationController.navigationController {
            navController.modalPresentationStyle = .overFullScreen
            navController.project = User.currentUser.projects[indexPath.row]
            self.present(navController, animated: true, completion: nil)
        }
    }
}
