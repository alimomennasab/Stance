//
//  NoTrueDepthVC.swift
//  NeckStretch
//
//  Created by xavier chia on 4/6/21.
//

import UIKit

class NoTrueDepthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        let activityController = UIActivityViewController(activityItems: [Shares.appLink], applicationActivities: nil)
        
        present(activityController, animated: true)
    }
    
}
