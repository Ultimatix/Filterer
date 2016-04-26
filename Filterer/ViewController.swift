//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var sliderView: UIView!
    var onScreenImage: UIImage?
    var newImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var comapreMenu: UIButton!
    @IBOutlet weak var imageMenu: UIImageView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    var currentImage: UIImage!
    @IBOutlet weak var sliderValue: UISlider!
    
    @IBAction func onSliderValueChange(sender: AnyObject) {
        print(sliderValue.value)
        
        let image = RGBAImage(image: self.newImage!)!
        
        let myRGB = image
        
        var totalGreen = 0
        var totalRed = 0
        var totalBlue = 0
        print("In Intensity")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalGreen += Int(pixel.green)
                totalRed += Int(pixel.red)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgGreen = totalGreen/count
        let avgBlue = totalBlue/count
        let avgRed = totalRed/count
        
        /* to enhance Green*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let greenDiff = Int(pixel.green) - avgGreen
                if(greenDiff > 0){
                    pixel.green = UInt8(max(0,min(255,avgGreen+greenDiff*Int(sliderValue.value))))
                    myRGB.pixels[index] = pixel
                }
                let redDiff = Int(pixel.red) - avgRed
                let blueDiff = Int(pixel.blue) - avgBlue
                if(redDiff > 0 && blueDiff > 0){
                    pixel.red = UInt8(max(0,min(255,avgRed+redDiff*Int(sliderValue.value))))
                    myRGB.pixels[index] = pixel
                    pixel.blue = UInt8(max(0,min(255,avgBlue+blueDiff*Int(sliderValue.value))))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        let newImage1 = myRGB.toUIImage()
        imageView.image = newImage1
       // self.newImage = myRGB.toUIImage()
        //imageView.image = self.newImage
        
    }
    
    func doAction(x: Int){
        print("At do action",x)
    }
    
    @IBOutlet var filterButton: UIButton!
    @IBAction func onEditButton(sender: AnyObject) {
        hideSecondaryMenu()
        showSlider()
        if (editButton.selected) {
            hideSlider()
            editButton.selected = false
        } else {
            showSlider()
            editButton.selected = true
        }

    }
    
    func showSlider(){
        view.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(bottomMenu.rightAnchor)
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()

    }
    func hideSlider(){
        sliderView.removeFromSuperview()
    }

    
    @IBAction func onCompareButtonStart(sender: AnyObject) {
        if comapreMenu.selected{
            
            imageView.image = newImage
            comapreMenu.selected = false
            
        }
        else{
            currentImage = self.onScreenImage
            let displayImage1 = writeText(currentImage)
            imageView.image = displayImage1
            comapreMenu.selected = true
        }

    }
    
    func shiftStart(sender: AnyObject) {
        showImage(self.newImage!)
        //imageView.image = newImage
    }

    
    func buttonToggle(){
        imageView.image = self.onScreenImage
    }
    
    
    func showImage(image: UIImage)  {
        UIView.transitionWithView(imageView,
                                  duration:1,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: { self.imageView.image = image},
                                  completion: nil)
    }
    
    func shiftEnd(sender: AnyObject){
        
        currentImage = self.onScreenImage
        let displayImage1 = writeText(currentImage)
        showImage(displayImage1)
        
    }
    func writeText(currentImage: UIImage) -> UIImage {
        
        let textToWrite: NSString = "Original"
        let textColor: UIColor = UIColor.orangeColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 8)!
        
        UIGraphicsBeginImageContext(currentImage.size)
        
        currentImage.drawInRect(CGRectMake(0, 0, currentImage.size.width, currentImage.size.height))
        let rect: CGRect = CGRectMake(CGPointMake(0, 0).x, CGPointMake(0, 0).y,currentImage.size.width, currentImage.size.height)
        
        textToWrite.drawInRect(rect, withAttributes: [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor])
        let displayImage1: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("write Text")
        print(displayImage1)
        return displayImage1
        
    }
 
    @IBAction func onPurpleButton(sender: AnyObject) {
        
        let image = RGBAImage(image: self.onScreenImage!)!
        
        let myRGB = image
        
        var totalRed = 0
        var totalBlue = 0
        print("In Yellow")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalRed += Int(pixel.red)
                totalBlue  += Int(pixel.blue)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgRed = totalRed/count
        let avgBlue = totalBlue/count
        
        /* to enhance Yellow*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                let blueDiff = Int(pixel.blue) - avgBlue
                if(redDiff > 0 && blueDiff > 0){
                    pixel.red = UInt8(max(0,min(255,avgRed+redDiff*10)))
                    myRGB.pixels[index] = pixel
                    pixel.blue = UInt8(max(0,min(255,avgBlue+blueDiff*10)))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        self.newImage = myRGB.toUIImage()
        imageView.image = self.newImage
        comapreMenu.enabled = true
        editButton.enabled = true
        
    }
    @IBAction func onYellowButton(sender: AnyObject) {
        
        let image = RGBAImage(image: self.onScreenImage!)!
        
        let myRGB = image
        
        var totalRed = 0
        var totalGreen = 0
        print("In Yellow")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen  += Int(pixel.green)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgRed = totalRed/count
        let avgGreen = totalGreen/count
        
        /* to enhance Yellow*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                let greenDiff = Int(pixel.green) - avgGreen
                if(redDiff > 0 && greenDiff > 0){
                    pixel.red = UInt8(max(0,min(255,avgRed+redDiff*10)))
                    myRGB.pixels[index] = pixel
                    pixel.green = UInt8(max(0,min(255,avgGreen+greenDiff*10)))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        self.newImage = myRGB.toUIImage()
        imageView.image = self.newImage
        comapreMenu.enabled = true
        editButton.enabled = true
       

        
    }
    @IBAction func onBlueButton(sender: AnyObject) {
        
        
        let image = RGBAImage(image: self.onScreenImage!)!
        
        let myRGB = image
        
        var totalBlue = 0
        print("In BLUE")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalBlue += Int(pixel.blue)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgBlue = totalBlue/count
        
        /* to enhance Blue*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let blueDiff = Int(pixel.blue) - avgBlue
                if(blueDiff > 0){
                    pixel.blue = UInt8(max(0,min(255,avgBlue+blueDiff*10)))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        self.newImage = myRGB.toUIImage()
        imageView.image = self.newImage
        comapreMenu.enabled = true
        editButton.enabled = true
       
    }
    @IBAction func onGreenButton(sender: UIButton) {
        
        let image = RGBAImage(image: self.onScreenImage!)!
        
        let myRGB = image
        
        var totalGreen = 0
        print("In Green")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalGreen += Int(pixel.green)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgGreen = totalGreen/count
        
        /* to enhance Green*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let greenDiff = Int(pixel.green) - avgGreen
                if(greenDiff > 0){
                    pixel.green = UInt8(max(0,min(255,avgGreen+greenDiff*10)))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        self.newImage = myRGB.toUIImage()
        imageView.image = self.newImage
        comapreMenu.enabled = true
        editButton.enabled = true
        
    }
    @IBAction func onRedButton(sender: UIButton) {
        
        let image = RGBAImage(image: self.onScreenImage!)!
        
        let myRGB = image
        
        var totalRed = 0
        print("In Red")
        
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                totalRed += Int(pixel.red)
            }
        }
        
        let count = myRGB.height * myRGB.width
        let avgRed = totalRed/count
        
        /* to enhance Red*/
        for y in 0..<myRGB.height{
            for x in 0..<myRGB.width{
                let index = y*myRGB.width + x
                var pixel = myRGB.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                if(redDiff > 0){
                    pixel.red = UInt8(max(0,min(255,avgRed+redDiff*10)))
                    myRGB.pixels[index] = pixel
                }
            }
        }
        
        self.newImage = myRGB.toUIImage()
        imageView.image = self.newImage
        comapreMenu.enabled = true
        editButton.enabled = true
        

    }
    


  var next: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redImage = UIImage(named: "Red.png")
        redButton.setImage(redImage, forState: .Normal)
        let blueImage = UIImage(named: "Blue.png")
        blueButton.setImage(blueImage, forState: .Normal)
        let greenImage = UIImage(named: "Green.png")
        greenButton.setImage(greenImage, forState: .Normal)
        let yellowImage = UIImage(named: "Yellow.png")
        yellowButton.setImage(yellowImage, forState: .Normal)
        let purpleImage = UIImage(named: "Purple.png")
        purpleButton.setImage(purpleImage, forState: .Normal)
        
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        self.onScreenImage = UIImage(named: "scenery")!
        comapreMenu.enabled = false
    
        imageView.userInteractionEnabled = true
        

        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.onLongPressImage(_:)))

        self.imageView.addGestureRecognizer(longPress)
        
    }
    
    
    func onLongPressImage(lp: UILongPressGestureRecognizer) {
        
        if (lp.state == UIGestureRecognizerState.Began) {
            shiftEnd(self.newImage!)
        
        }else{
            //showImage(self.newImage!)
            imageView.image = newImage
        }
   

    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.onScreenImage = image
            imageView.image = onScreenImage
            comapreMenu.enabled = false
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
        showSecondaryMenu()
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

