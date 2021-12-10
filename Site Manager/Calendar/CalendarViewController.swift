//
//  CalendarViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var increaseMonthButton: UIButton!
    @IBOutlet weak var decreaseMonthButton: UIButton!
    @IBOutlet weak var inspectionDateButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var siteInspections: [SiteInspection] {
        return SiteInspectionHelpers.siteInspections
    }
    
    var inspectionMonth: Int = Date().month {
        didSet {
            if inspectionMonth > 12 {
                inspectionYear += 1
                inspectionMonth = 1
            }
            collectionView.reloadData()
            reloadDateLabel()
        }
    }
    var inspectionYear: Int = Date().year {
        didSet {
            reloadDateLabel()
        }
    }
    
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func reloadDateLabel() {
        let date = Date.createDay(withYear: inspectionYear, month: inspectionMonth, day: 1)
        inspectionDateButton.setTitle(date.nameOfMonth + ", " + "\(date.year)", for: .normal)
    }
}

//MARK: Initialization
extension CalendarViewController {
    func initialize() {
        collectionView.register(CalendarCollectionViewCell.kNib, forCellWithReuseIdentifier: CalendarCollectionViewCell.kReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(SiteInspectionTableViewCell.kNib, forCellReuseIdentifier: SiteInspectionTableViewCell.kReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        increaseMonthButton.addTarget(self, action: #selector(increaseMonthButton_didPress), for: .touchUpInside)
        decreaseMonthButton.addTarget(self, action: #selector(decreaseMonthButton_didPress), for: .touchUpInside)
        
        reloadDateLabel()
    }
}

//MARK: Button Handlers
@objc extension CalendarViewController {
    func increaseMonthButton_didPress() {
        inspectionMonth += 1
        
    }
    
    func decreaseMonthButton_didPress() {
        inspectionMonth -= 1
    }
}

//MARK: Collection View Delegate and Data Source
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7*5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.kReuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        cell.date = getDateFromIndexPath(indexPath: indexPath)
        cell.selectedView.backgroundColor = UIColor.clear
        if cell.date.standardizedDate().compare(Date().standardizedDate()) == .orderedSame {
            cell.selectedView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        }
        
        if cell.date.standardizedDate().compare(selectedDate.standardizedDate()) == .orderedSame {
            cell.selectedView.backgroundColor = UIColor.blue
        }
        
        cell.siteInspections = getSiteInspectionsFromIndexPath(indexPath: indexPath)
        
        cell.performLayout()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = getDateFromIndexPath(indexPath: indexPath)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/7, height: collectionView.frame.size.height/5)
    }
    
    func getDateFromIndexPath(indexPath: IndexPath) -> Date {
        let date = Date.createDay(withYear: inspectionYear, month: inspectionMonth, day: 1)
        return date.dateInDaysFromNow(numberOfDays: indexPath.row).dateInDaysFromNow(numberOfDays: (-1*(date.dayOfWeek() ?? 0) + 1))
    }
    
    func getSiteInspectionsFromIndexPath(indexPath: IndexPath) -> [SiteInspection] {
        let date = getDateFromIndexPath(indexPath: indexPath)
        return siteInspections.filter({ date.standardizedDate().compare($0.date!.standardizedDate()) == .orderedSame }).sorted(by: { $0.date!.compare($1.date!) == .orderedAscending})
    }
}

//MARK: Table View Delegate and Data Source
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSelectedDatesSiteInspections().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteInspectionTableViewCell.kReuseIdentifier) as! SiteInspectionTableViewCell
        
        cell.siteInspection = getSelectedDatesSiteInspections()[indexPath.row]
        cell.performLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getSelectedDatesSiteInspections() -> [SiteInspection] {
        return siteInspections.filter({ selectedDate.standardizedDate().compare($0.date!.standardizedDate()) == .orderedSame }).sorted(by: { $0.date!.compare($1.date!) == .orderedAscending})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = SiteInspectionInitializationViewController.viewController {
//            vc.siteInspection = getSelectedDatesSiteInspections()[indexPath.row]
//            self.present(vc, animated: true, completion: nil)
//        }
    }
}
