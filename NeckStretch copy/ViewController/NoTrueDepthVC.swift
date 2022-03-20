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
