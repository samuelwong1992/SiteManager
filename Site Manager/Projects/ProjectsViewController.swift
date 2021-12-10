//
//  ProjectsViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProjectButton: UIButton!
    
    var projects: [Project] {
        return ProjectHelpers.projects
    }
    
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
        
        addProjectButton.addTarget(self, action: #selector(addProjectButton_didPress), for: .touchUpInside)
    }
}


//MARK: Button Handlers
@objc extension ProjectsViewController {
    func addProjectButton_didPress() {
        if let vc = NewProjectViewController.viewController {
            vc._delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: Table View Delegate and Data Source
extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.kReuseIdentifier) as! ProjectTableViewCell
        
        cell.project = projects[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navController = ProjectNavigationController.navigationController {
            navController.modalPresentationStyle = .overFullScreen
            navController.project = projects[indexPath.row]
            self.present(navController, animated: true, completion: nil)
        }
    }
}

//MARK: New Project View Controller Delegate
extension ProjectsViewController: NewProjectViewControllerDelegate {
    func newProjectViewController(newProjectViewController: NewProjectViewController, didCreateProject project: Project) {
        self.tableView.reloadData()
        if let navController = ProjectNavigationController.navigationController {
            navController.modalPresentationStyle = .overFullScreen
            navController.project = project
            self.present(navController, animated: true, completion: nil)
        }

    }
}
