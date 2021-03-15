//
//  SiteInspectionViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/21.
//

import UIKit

class SiteInspectionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var drawingImageViews: [UIImageView] = []
    var startTouch: CGPoint?
    var endTouch: CGPoint?
    var currentContext : CGContext?
    var tempImageStore: UIImage!
    var originalImage: UIImage!
    
    var siteInspectionObjectTuples: [(inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)] = []
    var selectedSiteObjectTuple: (inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)?
    var selectedCorner: Int?
    
    var siteImage = UIImage(named: "test_plan.jpg")
    
    enum InspectModes {
        case Scroll
        case Line
        case Square
        case Select
        
        var inspectionObjectType: SiteInspectionObject.SiteInspectionObjectType? {
            switch self {
            case .Scroll : return nil
            case .Line : return .Line
            case .Square : return .Square
            case .Select : return nil
            }
        }
    }
    
    var currentInspectMode: InspectModes = .Scroll {
        didSet {
            scrollButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            lineButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            squareButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            
            switch currentInspectMode {
            case .Scroll : scrollButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Line : lineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Square : squareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Select : selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionViewController {
    func initialize() {
        self.view.performTotalLayout()
        
        tableView.register(SiteInspectionNoteTableViewCell.kNib, forCellReuseIdentifier: SiteInspectionNoteTableViewCell.kReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 6
        scrollView.minimumZoomScale = 1
        
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.backgroundColor = .red
        imageViewHeightConstraint.constant = (imageView.image!.size.height*imageView.frame.size.width)/imageView.image!.size.width
        
        scrollButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        squareButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
    }
}

//MARK: Scroll View Delegate
extension SiteInspectionViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
}

//MARK: Button Handlers
@objc extension SiteInspectionViewController {
    func inspectModeButton_didPress(sender: UIButton) {
        switch sender {
        case scrollButton : currentInspectMode = .Scroll
        case lineButton : currentInspectMode = .Line
        case squareButton : currentInspectMode = .Square
        case selectButton : currentInspectMode = .Select
        default : break
        }
        
        scrollView.isUserInteractionEnabled = currentInspectMode == .Scroll
    }
}

//MARK: Touches Handlers
extension SiteInspectionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentInspectMode {
        case .Line, .Square :
            if let touch = touches.first {
                let drawingImageView = UIImageView(frame: self.imageView.bounds.withZeroOrigin)
                drawingImageView.isUserInteractionEnabled = true
                self.imageView.addSubview(drawingImageView)
                drawingImageViews.append(drawingImageView)
                startTouch = CGPoint(x: ((touch.location(in: imageView).x*imageView.image!.size.width)/imageView.frame.size.width)*scrollView.zoomScale, y: ((touch.location(in: imageView).y*imageView.image!.size.height)/imageView.frame.size.height)*scrollView.zoomScale)
                tempImageStore = imageView.image
                originalImage = imageView.image
            }
            
        case .Select :
            if let touch = touches.first {
                startTouch = touch.location(in: imageView)
                
                for siteObjectTuple in self.siteInspectionObjectTuples {
                    let hitView = siteObjectTuple.imageView.hitTest(touch.location(in: siteObjectTuple.imageView), with: event)
                    if let attachedView = siteObjectTuple.attachedView {
                        if attachedView === hitView {
                            self.drawFromScratch(siteInspectionObject: siteObjectTuple)
                            self.selectedSiteObjectTuple = siteObjectTuple
                            
                            if touch.location(in: attachedView).x < attachedView.frame.size.width / 10 {
                                if touch.location(in: attachedView).y < attachedView.frame.size.height / 10 {
                                    selectedCorner = 0
                                } else if touch.location(in: attachedView).y > 9*attachedView.frame.size.height / 10 {
                                    selectedCorner = 3
                                }
                            } else if touch.location(in: attachedView).x > 9*attachedView.frame.size.width / 10 {
                                if touch.location(in: attachedView).y < attachedView.frame.size.height / 10 {
                                    selectedCorner = 1
                                } else if touch.location(in: attachedView).y > 9*attachedView.frame.size.height / 10 {
                                    selectedCorner = 2
                                }
                            }
                        }
                    }
                }
            }
        default : break
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentInspectMode {
        case .Line :
            for touch in touches{
                endTouch = CGPoint(x: ((touch.location(in: imageView).x*imageView.image!.size.width)/imageView.frame.size.width)*scrollView.zoomScale, y: ((touch.location(in: imageView).y*imageView.image!.size.height)/imageView.frame.size.height)*scrollView.zoomScale)

                if self.currentContext == nil {
                    UIGraphicsBeginImageContext(imageView.image!.size)
                    self.currentContext = UIGraphicsGetCurrentContext()
                } else {
                    self.currentContext?.clear(CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height))
                }

                let bezier = UIBezierPath()

                bezier.move(to: startTouch!)
                bezier.addLine(to: endTouch!)
                bezier.close()

                UIColor.blue.set()

                self.currentContext?.setLineWidth(4)
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()
                let img2 = self.currentContext?.makeImage()
                drawingImageViews.last!.image = UIImage.init(cgImage: img2!)
            }
            
        case .Square :
            for touch in touches {
                endTouch = CGPoint(x: ((touch.location(in: imageView).x*imageView.image!.size.width)/imageView.frame.size.width)*scrollView.zoomScale, y: ((touch.location(in: imageView).y*imageView.image!.size.height)/imageView.frame.size.height)*scrollView.zoomScale)
                
                if self.currentContext == nil {
                    UIGraphicsBeginImageContext(imageView.image!.size)
                    self.currentContext = UIGraphicsGetCurrentContext()
                } else {
                    self.currentContext?.clear(CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height))
                }

                let bezier = UIBezierPath()

                bezier.move(to: startTouch!)
                bezier.addLine(to: CGPoint(x: endTouch!.x, y: startTouch!.y))
                bezier.addLine(to: endTouch!)
                bezier.addLine(to: CGPoint(x: startTouch!.x, y: endTouch!.y))
                bezier.close()
                bezier.fill()

                UIColor.blue.withAlphaComponent(0.2).set()

                self.currentContext?.setLineWidth(4)
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()
                let img2 = self.currentContext?.makeImage()
                drawingImageViews.last!.image = UIImage.init(cgImage: img2!)
            }
        case .Select :
            guard selectedSiteObjectTuple != nil else { return }
            if touches.count > 0 {
                let touch = touches.first!
                if let selectedView = selectedSiteObjectTuple!.attachedView {
                    if let corner = selectedCorner {
                        endTouch = touch.location(in: imageView)
                        selectedView.frame = selectedView.frame.addingSize(width: (corner == 3 || corner == 0 ? -1 : 1) * (endTouch!.x - startTouch!.x), height: (corner == 1 || corner == 0 ? -1 : 1) * (endTouch!.y - startTouch!.y)).offsetBy(dx: (corner == 0 || corner == 3) ? endTouch!.x - startTouch!.x : 0, dy: (corner == 0 || corner == 1) ? endTouch!.y - startTouch!.y : 0)
                        startTouch = endTouch
                    } else {
                        endTouch = touch.location(in: imageView)
                        selectedView.frame = selectedView.frame.offsetBy(dx: endTouch!.x - startTouch!.x, dy: endTouch!.y - startTouch!.y)
                        startTouch = endTouch
                    }
                    
                    if self.currentContext == nil {
                        UIGraphicsBeginImageContext(imageView.image!.size)
                        self.currentContext = UIGraphicsGetCurrentContext()
                    } else {
                        self.currentContext?.clear(CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height))
                    }
                    
                    tempImageStore?.draw(in: CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height))

                    let bezier = UIBezierPath()

                    bezier.move(to: selectedView.center.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale))
                    bezier.addLine(to: selectedSiteObjectTuple!.inspectionObject.coordinates.first!.midPointTo(point: selectedSiteObjectTuple!.inspectionObject.coordinates.last!))
                    bezier.close()

                    UIColor.blue.set()

                    self.currentContext?.setLineWidth(4)
                    self.currentContext?.addPath(bezier.cgPath)
                    self.currentContext?.strokePath()
                    let img2 = self.currentContext?.makeImage()
                    selectedSiteObjectTuple!.imageView.image = UIImage.init(cgImage: img2!)
                }
            }
        default : break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch self.currentInspectMode {
        case .Line, .Square:
            UIGraphicsEndImageContext()
            self.currentContext = nil
            
            let alert = UIAlertController(title: "Add Note", message: "Do you want to keep this marker?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.drawingImageViews.last!.removeFromSuperview()
            }))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let siteInspectionObject = SiteInspectionObject()
                siteInspectionObject.id = self.siteInspectionObjectTuples.count
                siteInspectionObject.coordinates = [self.startTouch!, self.endTouch!]
                siteInspectionObject.siteInspectionObjectType = self.currentInspectMode.inspectionObjectType
                
                self.siteInspectionObjectTuples.append((siteInspectionObject, nil, self.drawingImageViews.last!))
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Add with notes", style: .default, handler: { (action) in
                if let vc = SiteInspectionNotesViewController.viewController {
                    vc.inspectionTitle = "Item \(self.siteInspectionObjectTuples.count + 1)"
                    vc.returnBlock = { (title, description, note, actionBy) -> Void in
                        self.navigationController?.dismiss(animated: true, completion: nil)
                                                
                        let siteInspectionObject = SiteInspectionObject()
                        siteInspectionObject.id = self.siteInspectionObjectTuples.count
                        siteInspectionObject.coordinates = [self.startTouch!, self.endTouch!]
                        siteInspectionObject.siteInspectionObjectType = self.currentInspectMode.inspectionObjectType
                        siteInspectionObject.text = title
                        siteInspectionObject.description = description
                        siteInspectionObject.notes = note
                        siteInspectionObject.textCoordinates = [self.startTouch!]
                        
                        var label: UILabel?
                        if let touch = touches.first {
                            label = UILabel(frame: CGRect(origin: touch.location(in: self.imageView), size: CGSize(width: ((10*self.imageView.image!.size.width)/self.imageView.frame.size.width)*self.scrollView.zoomScale, height: ((7*self.imageView.image!.size.height)/self.imageView.frame.size.height)*self.scrollView.zoomScale)))
                            label!.backgroundColor = .white
                            label!.addBorder(colour: UIColor.blue.withAlphaComponent(0.3))
                            label!.numberOfLines = 0
                            let string = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
                            string.append(NSMutableAttributedString(string: "\n \(description)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
                            label!.attributedText = string
                            label!.adjustsFontSizeToFitWidth = true
                            label!.minimumScaleFactor = 0.1
                            label!.isUserInteractionEnabled = true
                            self.drawingImageViews.last!.addSubview(label!)
                            
                            self.drawLineBetweenPoints(startPoint: self.startTouch!.midPointTo(point: self.endTouch!), endPoint: label!.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: self.scrollView.zoomScale), inImageView: self.drawingImageViews.last!)
                        }
                        
                        self.siteInspectionObjectTuples.append((siteInspectionObject, label, self.drawingImageViews.last!))
                        self.tableView.reloadData()
                    }
                    self.navigationController?.present(vc, animated: true, completion: nil)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        case .Select :
            UIGraphicsEndImageContext()
            self.currentContext = nil
            selectedCorner = nil
            selectedSiteObjectTuple = nil
        default:
            break
        }
    }
}

//MARK: Drawers
extension SiteInspectionViewController {
    func drawFromScratch(siteInspectionObject: (inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)) {
        siteInspectionObject.imageView.image = UIImage()
        switch siteInspectionObject.inspectionObject.siteInspectionObjectType {
        case .Line :
            drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!, endPoint: siteInspectionObject.inspectionObject.coordinates.last!, inImageView: siteInspectionObject.imageView)
            tempImageStore = siteInspectionObject.imageView.image
            if let attachedView = siteInspectionObject.attachedView {
                drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!.midPointTo(point: siteInspectionObject.inspectionObject.coordinates.last!), endPoint: attachedView.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale), inImageView: siteInspectionObject.imageView)
            }
        case .Square :
            drawSquareBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!, endPoint: siteInspectionObject.inspectionObject.coordinates.last!, inImageView: siteInspectionObject.imageView)
            tempImageStore = siteInspectionObject.imageView.image
            if let attachedView = siteInspectionObject.attachedView {
                drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!.midPointTo(point: siteInspectionObject.inspectionObject.coordinates.last!), endPoint: attachedView.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale), inImageView: siteInspectionObject.imageView)
            }
        default : break
        }
    }
    
    func drawLineBetweenPoints(startPoint: CGPoint, endPoint: CGPoint, inImageView imageView: UIImageView) {
        UIGraphicsBeginImageContext(self.imageView.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        let bezier = UIBezierPath()
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: self.imageView.image!.size))
        
        bezier.move(to: startPoint)
        bezier.addLine(to: endPoint)
        bezier.close()

        UIColor.blue.set()

        context?.setLineWidth(4)
        context?.addPath(bezier.cgPath)
        context?.strokePath()
        let img2 = context?.makeImage()
        imageView.image = UIImage.init(cgImage: img2!)
        UIGraphicsEndImageContext()
    }
    
    func drawSquareBetweenPoints(startPoint: CGPoint, endPoint: CGPoint, inImageView imageView: UIImageView) {
        UIGraphicsBeginImageContext(self.imageView.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: self.imageView.image!.size))
        
        let bezier = UIBezierPath()

        UIColor.blue.withAlphaComponent(0.2).set()
        
        bezier.move(to: startPoint)
        bezier.addLine(to: CGPoint(x: endPoint.x, y: startPoint.y))
        bezier.addLine(to: endPoint)
        bezier.addLine(to: CGPoint(x: startPoint.x, y: endPoint.y))
        bezier.close()
        bezier.fill()

        context?.setLineWidth(4)
        context?.addPath(bezier.cgPath)
        context?.strokePath()
        let img2 = context?.makeImage()
        imageView.image = UIImage.init(cgImage: img2!)
        UIGraphicsEndImageContext()
    }
}

extension SiteInspectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteInspectionObjectTuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteInspectionNoteTableViewCell.kReuseIdentifier) as! SiteInspectionNoteTableViewCell
        
        cell.siteInspectionObject = siteInspectionObjectTuples[indexPath.row].inspectionObject
        if(siteInspectionObjectTuples[indexPath.row].imageView.isHidden) {
            cell.hideButton.setTitle("Show", for: .normal)
        } else {
            cell.hideButton.setTitle("Hide", for: .normal)
        }
        cell._delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SiteInspectionViewController: SiteInspectionNoteTableViewCellDelegate {
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressHideForSiteInspectionObject siteInspectionObject: SiteInspectionObject) {
        for sio in siteInspectionObjectTuples.filter({ $0.inspectionObject.id == siteInspectionObject.id}) {
            sio.imageView.isHidden = !sio.imageView.isHidden
        }
        self.tableView.reloadData()
    }
    
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressDeleteForSiteInspectionObject siteInspectionObject: SiteInspectionObject) {
        for sio in siteInspectionObjectTuples.filter({ $0.inspectionObject.id == siteInspectionObject.id}) {
            sio.imageView.removeFromSuperview()
        }
        siteInspectionObjectTuples.removeAll(where: { $0.inspectionObject.id == siteInspectionObject.id})
        self.tableView.reloadData()
    }
}
