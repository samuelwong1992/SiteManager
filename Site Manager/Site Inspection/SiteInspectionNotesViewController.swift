//
//  SiteInspectionNotesViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 15/2/21.
//

import UIKit

class SiteInspectionNotesViewController: UIViewController {
    
    static var viewController: SiteInspectionNotesViewController? {
        return StoryboardConstants.Storyboard.SiteInspectionStoryboard.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionNotesViewController.identifier) as? SiteInspectionNotesViewController
    }
    
    var inspectionTitle: String?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var actionByTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var attachments: [Attachment] = []
    var project: Project?
    var returnBlock: ((_ title: String, _ description: String, _ note: String, _ actionBy: String, _ attachments: [Attachment]) -> Void)?
    
    var siteInspectionObject: SiteInspectionObject?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionNotesViewController {
    func initialize() {
        self.addBackgroundViewDismissKeyboardRecognizer()
        
        if let inspectionTitle = inspectionTitle {
            titleTextField.text = inspectionTitle
        }
        
        collectionView.register(ImageCollectionViewCell.kNib, forCellWithReuseIdentifier: ImageCollectionViewCell.kReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoButton_didPress), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButton_didPress), for: .touchUpInside)
        
        setupForSiteInspectionObject()
    }
    
    func setupForSiteInspectionObject() {
        if let sio = siteInspectionObject {
            titleTextField.text = sio.text
            descriptionTextField.text = sio.information
            noteTextField.text = sio.notes
            actionByTextField.text = sio.actionBy
            
            attachments = sio.attachmentsArray
            
            titleTextField.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            noteTextField.isUserInteractionEnabled = false
            actionByTextField.isUserInteractionEnabled = false
            
            addPhotoButton.isHidden = true
        }
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionNotesViewController {
    func doneButton_didPress() {
        if let returnBlock = returnBlock {
            returnBlock(titleTextField.text ?? "", descriptionTextField.text ?? "", noteTextField.text ?? "", actionByTextField.text ?? "", self.attachments)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addPhotoButton_didPress() {
        let alert = UIAlertController(title: "Add Attachment", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Shop Drawing", style: .default, handler: { action in
            if let vc = DrawingsViewController.viewController {
                vc.project = self.project
                vc.isForShopDrawing = true
                vc.isForAttachment = true
                vc._delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { action in
            if let vc = DrawingsViewController.viewController {
                vc.project = self.project
                vc.isForShopDrawing = false
                vc.isForAttachment = true
                vc._delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Drawings View Controller Delegate
extension SiteInspectionNotesViewController: DrawingsViewControllerDelegate {
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectDrawing drawing: Drawings) {}
    
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectAttachment attachment: Attachment) {
        self.attachments.append(attachment)
        self.collectionView.reloadData()
        drawingsViewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: Collection View Delegate
extension SiteInspectionNotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.kReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.image = attachments[indexPath.row].image
        cell.imageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageDisplayViewController()
        vc.image = attachments[indexPath.row].image
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { elements in
            return UIMenu(title: "", image: nil, identifier: nil, options: .singleSelection, children: [UIAction(title: "Remove", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: UIMenuElement.State.on, handler: { action in
                self.attachments.remove(at: indexPath.row)
            })])
        }
    }
}
