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
    @IBOutlet weak var freeFormButton: UIButton!
    @IBOutlet weak var colourButton: UIButton!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedColour: UIColor = .blue
    
    var siteInpsection: SiteInspection! {
        get {
            return (self.navigationController as! SiteInspectionNavigationController).siteInspection
        }
    }
    
    var drawingImageViews: [UIImageView] = []
    var startTouch: CGPoint?
    var endTouch: CGPoint?
    var freeFormPoints: [CGPoint] = []
    var currentContext : CGContext?
    var tempImageStore: UIImage!
    var originalImage: UIImage!
    
    var siteInspectionObjectTuples: [(inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)] = []
    var selectedSiteObjectTuple: (inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)?
    var selectedCorner: Int?
        
    enum InspectModes {
        case Scroll
        case Line
        case Square
        case FreeForm
        case Select
        
        var inspectionObjectType: SiteInspectionObject.SiteInspectionObjectType? {
            switch self {
            case .Scroll : return nil
            case .Line : return .Line
            case .Square : return .Square
            case .FreeForm : return .FreeForm
            case .Select : return nil
            }
        }
    }
    
    var currentInspectMode: InspectModes = .Scroll {
        didSet {
            scrollButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            lineButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            squareButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            freeFormButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            
            switch currentInspectMode {
            case .Scroll : scrollButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Line : lineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Square : squareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .FreeForm : freeFormButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            case .Select : selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.performTotalLayout()
        
        for siteInspectionObject in siteInpsection.siteInspectionObjectsArray {
            let drawingImageView = UIImageView(frame: self.imageView.bounds.withZeroOrigin)
            drawingImageView.isUserInteractionEnabled = true
            self.imageView.addSubview(drawingImageView)
            drawingImageViews.append(drawingImageView)
                
            addSiteInspectionObject(forDrawing: true, siteInspectionObject: siteInspectionObject, onImageView: drawingImageView)
        }
    }
    
    func addSiteInspectionObject(forDrawing draw: Bool, siteInspectionObject: SiteInspectionObject, onImageView imageView: UIImageView) {
        var labelContainer: UIView?
                    
        if siteInspectionObject.textXCoord != 0 && siteInspectionObject.textYCoord != 0 {
            labelContainer = UIView(frame: CGRect(origin: CGPoint(x: siteInspectionObject.textXCoord, y: siteInspectionObject.textYCoord), size: CGSize(width: siteInspectionObject.textWidth, height: siteInspectionObject.textHeight)))
            let label = UILabel(frame: CGRect(origin: CGPoint(x: siteInspectionObject.textXCoord, y: siteInspectionObject.textYCoord), size: CGSize(width: siteInspectionObject.textWidth, height: siteInspectionObject.textHeight)))
            labelContainer!.backgroundColor = .white
            labelContainer!.addBorder(colour: siteInspectionObject.uiColor.withAlphaComponent(0.3))
            labelContainer!.isUserInteractionEnabled = true
            label.numberOfLines = 0
            let string = NSMutableAttributedString(string: siteInspectionObject.text ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
            if !String.isNilOrEmpty(siteInspectionObject.notes) {
                string.append(NSMutableAttributedString(string: "\n" + siteInspectionObject.notes!, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
            }
            label.attributedText = string
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.1
            labelContainer!.addSubView(subview: label, toTop: true, marginTop: 4, toBottom: true, marginBottom: -4, toRightEdge: true, marginRight: -4, toLeftEdge: true, marginLeft: 4)
            imageView.addSubview(labelContainer!)
        }
        
        let inspectionObject = (inspectionObject: siteInspectionObject, attachedView: labelContainer, imageView: imageView)
        self.siteInspectionObjectTuples.append(inspectionObject)

        if draw {
            drawFromScratch(siteInspectionObject: inspectionObject)
        }
                
        tableView.reloadData()
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
        imageView.image = siteInpsection.drawing?.image
        imageViewHeightConstraint.constant = (imageView.image!.size.height*imageView.frame.size.width)/imageView.image!.size.width
        
        scrollButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        squareButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        freeFormButton.addTarget(self, action: #selector(inspectModeButton_didPress(sender:)), for: .touchUpInside)
        colourButton.addTarget(self, action: #selector(colourButton_didPress), for: .touchUpInside)
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
        case freeFormButton : currentInspectMode = .FreeForm
        case selectButton : currentInspectMode = .Select
        default : break
        }
        
        scrollView.isUserInteractionEnabled = currentInspectMode == .Scroll
    }
    
    func colourButton_didPress() {
        let vc = UIColorPickerViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: Colour Picker Delegate
extension SiteInspectionViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.selectedColour = color
    }
}

//MARK: Touches Handlers
extension SiteInspectionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentInspectMode {
        case .Line, .Square, .FreeForm :
            if let touch = touches.first {
                if self.freeFormPoints.isEmpty {
                    let drawingImageView = UIImageView(frame: self.imageView.bounds.withZeroOrigin)
                    drawingImageView.isUserInteractionEnabled = true
                    self.imageView.addSubview(drawingImageView)
                    drawingImageViews.append(drawingImageView)
                    startTouch = CGPoint(x: ((touch.location(in: imageView).x*imageView.image!.size.width)/imageView.frame.size.width)*scrollView.zoomScale, y: ((touch.location(in: imageView).y*imageView.image!.size.height)/imageView.frame.size.height)*scrollView.zoomScale)
                    tempImageStore = imageView.image
                    originalImage = imageView.image
                }
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
                            
                            if touch.location(in: attachedView).x < attachedView.frame.size.width / 7 {
                                if touch.location(in: attachedView).y < attachedView.frame.size.height / 7 {
                                    selectedCorner = 0
                                } else if touch.location(in: attachedView).y > 6*attachedView.frame.size.height / 7 {
                                    selectedCorner = 3
                                }
                            } else if touch.location(in: attachedView).x > 6*attachedView.frame.size.width / 7 {
                                if touch.location(in: attachedView).y < attachedView.frame.size.height / 7 {
                                    selectedCorner = 1
                                } else if touch.location(in: attachedView).y > 6*attachedView.frame.size.height / 7 {
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

                selectedColour.set()

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

                selectedColour.withAlphaComponent(0.2).set()

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

                    selectedSiteObjectTuple?.inspectionObject.uiColor.set()

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
            finishDrawing(coords: [self.startTouch!, self.endTouch!], lastTouch: touches.first!.location(in: self.imageView))
            
        case .FreeForm :
            if let touch = touches.first {
                endTouch = CGPoint(x: ((touch.location(in: imageView).x*imageView.image!.size.width)/imageView.frame.size.width)*scrollView.zoomScale, y: ((touch.location(in: imageView).y*imageView.image!.size.height)/imageView.frame.size.height)*scrollView.zoomScale)
                freeFormPoints.append(endTouch!)
                if self.currentContext == nil {
                    UIGraphicsBeginImageContext(imageView.image!.size)
                    self.currentContext = UIGraphicsGetCurrentContext()
                } else {
                    self.currentContext?.clear(CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height))
                }

                let bezier = UIBezierPath()

                bezier.move(to: startTouch!)
                
                for point in freeFormPoints {
                    bezier.addLine(to: point)
                }
                
                if freeFormPoints.count > 1 {
                    if let firstTouch = freeFormPoints.first {
                        if let lastTouch = freeFormPoints.last {
                            if (Int(abs(Double(firstTouch.x - lastTouch.x))) < 50) && (Int(abs(Double(firstTouch.y - lastTouch.y))) < 50) {
                                bezier.close()
                                bezier.fill()
                            }
                        }
                    }
                } else {
                    let circlePath = UIBezierPath(arcCenter: startTouch!, radius: 30, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
                    selectedColour.setFill()
                    circlePath.fill()
                    self.currentContext?.addPath(circlePath.cgPath)
                }

                selectedColour.withAlphaComponent(0.2).set()

                self.currentContext?.setLineWidth(4)
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()
                let img2 = self.currentContext?.makeImage()
                drawingImageViews.last!.image = UIImage.init(cgImage: img2!)
                
                if freeFormPoints.count > 1 {
                    if let firstTouch = freeFormPoints.first {
                        if let lastTouch = freeFormPoints.last {
                            if (Int(abs(Double(firstTouch.x - lastTouch.x))) < 50) && (Int(abs(Double(firstTouch.y - lastTouch.y))) < 50) {
                                finishDrawing(coords: self.freeFormPoints, lastTouch: touches.first!.location(in: self.imageView))
                                self.freeFormPoints = []
                            }
                        }
                    }
                }
            }
        case .Select :
            UIGraphicsEndImageContext()
            if let selectedSiteObjectTuple = selectedSiteObjectTuple {
                if let attachedView = selectedSiteObjectTuple.attachedView {
                    SiteInspectionObjectHelpers.updateSiteInspectionObject(siteInspectionObject: selectedSiteObjectTuple.inspectionObject, textLocation: attachedView.frame)
                }
            }
            
            self.currentContext = nil
            selectedCorner = nil
            selectedSiteObjectTuple = nil
        default:
            break
        }
    }
    
    func finishDrawing(coords: [CGPoint], lastTouch: CGPoint) {
        UIGraphicsEndImageContext()
        self.currentContext = nil
        
        let alert = UIAlertController(title: "Add Note", message: "Do you want to keep this marker?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.drawingImageViews.last!.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let siteInspectionObjectContainer = SiteInspectionObjectHelpers.createSiteInspectionObject(forSiteInspection: self.siteInpsection, siObjectType: self.currentInspectMode.inspectionObjectType!, colour: self.selectedColour.hexCode, coords: coords)
        
            if let error = siteInspectionObjectContainer.error {
                UIAlertController.showAlertWithError(viewController: self, error: error)
            } else if let siteInspectionObject = siteInspectionObjectContainer.siteInspectionObject {
                self.siteInspectionObjectTuples.append((siteInspectionObject, nil, self.drawingImageViews.last!))
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Add With Notes", style: .default, handler: { (action) in
            if let vc = SiteInspectionNotesViewController.viewController {
                vc.project = self.siteInpsection.project
                vc.inspectionTitle = "Item \(self.siteInspectionObjectTuples.count + 1)"
                vc.returnBlock = { (title, description, note, actionBy, attachments) -> Void in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                                 
                    let siteInspectionObjectContainer = SiteInspectionObjectHelpers.createSiteInspectionObject(forSiteInspection: self.siteInpsection, siObjectType: self.currentInspectMode.inspectionObjectType!, colour: self.selectedColour.hexCode, coords: coords, text: title, information: description, notes: note, actionBy: actionBy, textXCoord: lastTouch.x, textYCoord: lastTouch.y, textHeight: ((7*self.imageView.image!.size.height)/self.imageView.frame.size.height)*self.scrollView.zoomScale, textWidth: ((10*self.imageView.image!.size.width)/self.imageView.frame.size.width)*self.scrollView.zoomScale, attachments: attachments)
                    
                    if let error = siteInspectionObjectContainer.error {
                        UIAlertController.showAlertWithError(viewController: self, error: error)
                    } else if let siteInspectionObject = siteInspectionObjectContainer.siteInspectionObject {
                        self.addSiteInspectionObject(forDrawing: false, siteInspectionObject: siteInspectionObject, onImageView: self.drawingImageViews.last!)
                    }
                }
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Add Related To Other Marker", style: .default, handler: { action in
            let alert = UIAlertController(title: "Related To", message: "Which Marker is this Marker tied to?", preferredStyle: .alert)
            
            for sio in self.siteInpsection.siteInspectionObjectsArray {
                if sio.link == nil {
                    alert.addAction(UIAlertAction(title: sio.text, style: .default, handler: { action in
                        let siteInspectionObjectContainer = SiteInspectionObjectHelpers.createSiteInspectionObject(forSiteInspection: self.siteInpsection, withLinkToSiteInspecionObject: sio, siObjectType: self.currentInspectMode.inspectionObjectType!, colour: self.selectedColour.hexCode, coords: coords)
                        
                        if let error = siteInspectionObjectContainer.error {
                            UIAlertController.showAlertWithError(viewController: self, error: error)
                        } else if let siteInspectionObject = siteInspectionObjectContainer.siteInspectionObject {
                            self.siteInspectionObjectTuples.append((siteInspectionObject, nil, self.drawingImageViews.last!))
                            self.tableView.reloadData()
                        }
                    }))
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Drawers
extension SiteInspectionViewController {
    func drawFromScratch(siteInspectionObject: (inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)) {
        siteInspectionObject.imageView.image = UIImage()
        switch siteInspectionObject.inspectionObject.siteInspectionObjectType {
        case .Line :
            drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!, endPoint: siteInspectionObject.inspectionObject.coordinates.last!, inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            tempImageStore = siteInspectionObject.imageView.image
            if let attachedView = siteInspectionObject.attachedView {
                drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!.midPointTo(point: siteInspectionObject.inspectionObject.coordinates.last!), endPoint: attachedView.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale), inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            }
        case .Square :
            drawSquareBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!, endPoint: siteInspectionObject.inspectionObject.coordinates.last!, inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            tempImageStore = siteInspectionObject.imageView.image
            if let attachedView = siteInspectionObject.attachedView {
                drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!.midPointTo(point: siteInspectionObject.inspectionObject.coordinates.last!), endPoint: attachedView.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale), inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            }
        case .FreeForm :
            drawFreeFormWithPoints(points: siteInspectionObject.inspectionObject.coordinates, inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            tempImageStore = siteInspectionObject.imageView.image
            if let attachedView = siteInspectionObject.attachedView {
                drawLineBetweenPoints(startPoint: siteInspectionObject.inspectionObject.coordinates.first!.midPointTo(point: siteInspectionObject.inspectionObject.coordinates.last!), endPoint: attachedView.frame.midpoint.translatedToProportionalArea(size1: self.imageView.image!.size, size2: self.imageView.frame.size, zoomScale: scrollView.zoomScale), inImageView: siteInspectionObject.imageView, color: siteInspectionObject.inspectionObject.uiColor)
            }
        }
    }
    
    func drawLineBetweenPoints(startPoint: CGPoint, endPoint: CGPoint, inImageView imageView: UIImageView, color: UIColor) {
        UIGraphicsBeginImageContext(self.imageView.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        let bezier = UIBezierPath()
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: self.imageView.image!.size))
        
        bezier.move(to: startPoint)
        bezier.addLine(to: endPoint)
        bezier.close()

        color.set()

        context?.setLineWidth(4)
        context?.addPath(bezier.cgPath)
        context?.strokePath()
        let img2 = context?.makeImage()
        imageView.image = UIImage.init(cgImage: img2!)
        UIGraphicsEndImageContext()
    }
    
    func drawSquareBetweenPoints(startPoint: CGPoint, endPoint: CGPoint, inImageView imageView: UIImageView, color: UIColor) {
        UIGraphicsBeginImageContext(self.imageView.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: self.imageView.image!.size))
        
        let bezier = UIBezierPath()

        color.withAlphaComponent(0.2).set()
        
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
    
    func drawFreeFormWithPoints(points: [CGPoint], inImageView imageView: UIImageView, color: UIColor) {
        guard points.count > 0 else { return }
        UIGraphicsBeginImageContext(self.imageView.image!.size)
        let context = UIGraphicsGetCurrentContext()
        
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: self.imageView.image!.size))
        
        let bezier = UIBezierPath()

        color.withAlphaComponent(0.2).set()
        
        bezier.move(to: points.first!)
        for point in points {
            bezier.addLine(to: point)
        }
        bezier.close()
        bezier.fill()

        context?.setLineWidth(4)
        context?.addPath(bezier.cgPath)
        context?.strokePath()
        let img2 = context?.makeImage()
        imageView.image = UIImage.init(cgImage: img2!)
        UIGraphicsEndImageContext()
    }
    
    func rotate(path: UIBezierPath, degree: CGFloat) {
        let bounds: CGRect = path.cgPath.boundingBox
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let radians = degree / 180.0 * .pi
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        path.apply(transform)
    }
}

extension SiteInspectionViewController: UITableViewDelegate, UITableViewDataSource {
    func siteInspectionObjectsWithNoLink() -> [(inspectionObject: SiteInspectionObject, attachedView: UIView?, imageView: UIImageView)] {
        return siteInspectionObjectTuples.filter({ $0.inspectionObject.link == nil })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteInspectionObjectsWithNoLink().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteInspectionNoteTableViewCell.kReuseIdentifier) as! SiteInspectionNoteTableViewCell
        
        cell.siteInspectionObject = siteInspectionObjectsWithNoLink()[indexPath.row].inspectionObject
        if(siteInspectionObjectsWithNoLink()[indexPath.row].imageView.isHidden) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = SiteInspectionNotesViewController.viewController {
            vc.siteInspectionObject = siteInspectionObjectsWithNoLink()[indexPath.row].inspectionObject
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension SiteInspectionViewController: SiteInspectionNoteTableViewCellDelegate {
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressHideForSiteInspectionObject siteInspectionObject: SiteInspectionObject) {
        for sio in siteInspectionObjectTuples.filter({ $0.inspectionObject.id == siteInspectionObject.id}) {
            sio.imageView.isHidden = !sio.imageView.isHidden
            
            for linkedSIO in sio.inspectionObject.linkedSiteInspectionObjectsArray {
                for sio in siteInspectionObjectTuples.filter({ $0.inspectionObject.id == linkedSIO.id}) {
                    sio.imageView.isHidden = !sio.imageView.isHidden
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func siteInspectionNoteTableViewCell(siteInspectionNoteTableViewCell: SiteInspectionNoteTableViewCell, didPressDeleteForSiteInspectionObject siteInspectionObject: SiteInspectionObject) {
        let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            for sio in self.siteInspectionObjectTuples.filter({ $0.inspectionObject.id == siteInspectionObject.id}) {
                sio.imageView.removeFromSuperview()
                sio.inspectionObject.delete()
            }
            self.siteInspectionObjectTuples.removeAll(where: { $0.inspectionObject.id == siteInspectionObject.id})
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
