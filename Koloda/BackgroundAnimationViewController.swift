//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import SCLAlertView
import SwiftSpinner
import GTProgressBar
private let numberOfCards: Int = 3
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class profile {
    
    var address: String!
    var dna: String!
    var imageName: String!

    init (_address: String, _dna: String, _imageName: String) {
        address = _address as? String
        dna = _dna as? String
        imageName = _imageName as? String
    }

}

class BackgroundAnimationViewController: UIViewController{

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    var profiles = [profile]()
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    @IBOutlet weak var similarityText: UILabel!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profiles.append(profile(_address: "GCK2SR2S6YQ7C5BTJ2RQDJE47Y2RHRH6MQ6YMDG5UFPMACE7GBX2JL32", _dna: "CCGACACGAACCTCAGTTGGCCTACATCCTACCTGAGGTCTGTGCCCCGGTGGTGAGAAGTGCG", _imageName: "bob"))
        profiles.append(profile(_address: "GAR6ULSSWWJUYAK675V2NUJ6JEXSIPYHP3U5TQI3N7VZP2R567X4KELG", _dna: "CATTTCGTTCTTGCAGCTCGTCAGTACTTTCAGAATCATGGCCTGCACGGTAGAATGACGCTTA", _imageName: "jon"))
        profiles.append(profile(_address: "GBGRZA5XFIMH4AARTBWOLFHQCIUVFTM7QT5CJZKII5KK4DXZTUCZ5XMM", _dna: "TAATGGACTTCGACATGGCAATAACCCCCCGTTTCTACCTCAAGAGGAGAAAAGTATTAACATG", _imageName: "lane"))
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
  
       
        
        
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        
        let alertView = SCLAlertView()
        alertView.addButton("Continue (0.01Ξ)"){
            print("First button tapped")
            SwiftSpinner.show(duration: 4.0, title: "Processing Payment")
            let number = "sms:+12345678901"
            UIApplication.shared.openURL(NSURL(string: number)! as URL)
            self.kolodaView?.swipe(.right)
        }
        alertView.showSuccess("You matched!", subTitle: "They also liked you!")
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        //ratingView.clearsContextBeforeDrawing = true
        addressLabel.text = profiles[index].address
        print("address \(profiles[index].address)")
        let number2 = arc4random_uniform(50) + 50
        //similarityText.text = String("\(number2)%")
        let progressBar = GTProgressBar(frame: CGRect(x: 20, y: 20, width: (ratingView.frame.width - 40) , height: 30))
        print(number2)
        
        let arc4randoMax:Double = 0x100000000
        let upper = 1.0
        let lower = 0.5
        let ab = Float32((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower)
        
        progressBar.progress = CGFloat(ab)
        progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barBackgroundColor = UIColor(red:1, green:1, blue:1, alpha:1.0)
        progressBar.barBorderWidth = 0.5
        progressBar.barFillInset = 2
        progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        progressBar.labelPosition = GTProgressBarLabelPosition.top
        progressBar.barMaxHeight = 40
        progressBar.direction = GTProgressBarDirection.clockwise
        
        ratingView.addSubview(progressBar)
        //ratingView.setNeedsDisplay()
       
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return numberOfCards
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: UIImage(named: "person\(index + 1)"))

    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
