//
//  ViewController.swift
//  ChildMonitoringApp
//
//  Created by Benitha Sri Panchagiri on 11/11/24.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        animateImageToPosition()
    }
    
    func animateImageToPosition() {
            // Save the original frame of the image
            let originalFrame = imageView.frame
            
            // Make the image fill the screen
            imageView.frame = UIScreen.main.bounds
            
            // Animate back to its original position
            UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
                self.imageView.frame = originalFrame
            }, completion: nil)
        } 
}

