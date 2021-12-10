//
//  DrawingsViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit
import PhotosUI

protocol DrawingsViewControllerDelegate {
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectDrawing drawing: Drawings)
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectAttachment attachment: Attachment)
}

class DrawingsViewController: ProjectBaseViewController, UINavigationControllerDelegate {
    
    static var viewController: DrawingsViewController? {
        return StoryboardConstants.Storyboard.Project.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.ProjectDrawings.identifier) as? DrawingsViewController
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    var _delegate: DrawingsViewControllerDelegate?
    var isForAttachment: Bool = false
    var isForShopDrawing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    func openImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: Initialization
extension DrawingsViewController {
    func initialize() {
        collectionView.register(ImageCollectionViewCell.kNib, forCellWithReuseIdentifier: ImageCollectionViewCell.kReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: Collection View Delegate and Data Source
extension DrawingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isForAttachment {
            if isForShopDrawing {
                return project.shopDrawingArray.count + 1
            } else {
                return project.photoArray.count + 1
            }
        } else {
            return project.drawingsArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.kReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        if indexPath.row == 0 {
            cell.image = UIImage(named: "ic_new")
            cell.imageView.contentMode = .center
        } else {
            if isForAttachment {
                if isForShopDrawing {
                    cell.image = project.shopDrawingArray[indexPath.row - 1].image
                } else {
                    cell.image = project.photoArray[indexPath.row - 1].image
                }
            } else {
                cell.image = project.drawingsArray[indexPath.row - 1].image
            }
            cell.imageView.contentMode = .scaleAspectFit
        }
        
        cell.addBorder(colour: .black)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if isForAttachment && !isForShopDrawing {
                let alert = UIAlertController(title: "Add Photo", message: "Add from albumn or take photo now?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Albumn", style: .default, handler: { _ in
                    self.openImagePicker()
                }))
                alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                openImagePicker()
            }
        } else {
            if _delegate == nil {
                let vc = ImageDisplayViewController()
                if isForAttachment {
                    if isForShopDrawing {
                        vc.image = project.shopDrawingArray[indexPath.row - 1].image
                    } else {
                        vc.image = project.photoArray[indexPath.row - 1].image
                    }
                } else {
                    vc.image = project.drawingsArray[indexPath.row - 1].image
                }
                self.present(vc, animated: true, completion: nil)
            } else {
                if isForAttachment {
                    if isForShopDrawing {
                        _delegate?.drawingsViewController(drawingsViewController: self, didSelectAttachment: project.shopDrawingArray[indexPath.row - 1])
                    } else {
                        _delegate?.drawingsViewController(drawingsViewController: self, didSelectAttachment: project.photoArray[indexPath.row - 1])
                    }
                } else {
                    _delegate?.drawingsViewController(drawingsViewController: self, didSelectDrawing: project.drawingsArray[indexPath.row - 1])
                }
            }
        }
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
}

//MARK: Camera Picker Delegate
extension DrawingsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        AttachmentHelpers.createAttachment(forProject: self.project, fromImage: image, isPhoto: true)
        picker.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
}

//MARK: PH Picker Delegate
extension DrawingsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        if self.isForAttachment {
                            if self.isForShopDrawing {
                                AttachmentHelpers.createAttachment(forProject: self.project, fromImage: image, isPhoto: false)
                            } else {
                                AttachmentHelpers.createAttachment(forProject: self.project, fromImage: image, isPhoto: true)
                            }
                        } else {
                             DrawingsHelpers.createDrawing(forProject: self.project, fromImage: image)
                        }
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}
