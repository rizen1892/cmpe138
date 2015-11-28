

import UIKit
import Parse

class BasicInfoViewController2: UIViewController {

    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var State: UITextField!
    @IBOutlet weak var Zip: UITextField!
    @IBOutlet weak var frequency: UITextField!
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        
        var currentUser = PFUser.currentUser()
        currentUser = nil
        if currentUser == nil {
            self.dismissViewControllerAnimated(true, completion:nil)
        }

    }
    var count = 0
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            // self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func saveInfo(sender: AnyObject) {
        
        if (cardNumber.text == "" || street.text == "" || city.text == "" || State.text == "" || Zip.text == "" || frequency.text == ""  ){
            
            displayAlert("Error in form", message: "Please enter all thei information")
            
        }
        else{
        if let currentUser = PFUser.currentUser(){
            currentUser["CardNumber"] = cardNumber.text
            currentUser["Street"] = street.text
            currentUser["City"] = city.text
            currentUser["State"] = State.text
            currentUser["ZipCode"] = Zip.text
            currentUser["Freqency"] = frequency.text
            count = 1;
            //set other fields the same way....
            currentUser.saveInBackground()
            
            displayAlert("Saved", message: "Your information has been updated.")
            
        }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            
        })
        
        if let currentUser = PFUser.currentUser(){
            
            self.cardNumber.placeholder = currentUser["CardNumber"] as! String?
            self.street.placeholder =  currentUser["Street"] as! String?
            self.city.placeholder = currentUser["City"] as! String?
            self.State.placeholder = currentUser["State"] as! String?
            self.Zip.placeholder =  currentUser["ZipCode"] as! String?
            self.frequency.placeholder = currentUser["Freqency"] as! String?
            
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
