//
//  CompanyViewController.swift
//  
//
//  Created by Rizen Yamauchi on 11/26/15.
//
//

import UIKit
import Parse

class CompanyViewController: UIViewController {
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addLocation: UITextField!
    
    
    @IBAction func SaveCompany(sender: AnyObject) {
        if (addLocation.text == ""){
            
            displayAlert("Error in form", message: "Please enter all the information")
            
        }
        else{
              var company = PFObject(className: "Companies")
                
                company["Name"] = PFUser.currentUser()!.objectId!
                company["Location"] = addLocation.text
                //set other fields the same way....
                company.saveInBackground()
                
                displayAlert("Saved", message: "Your information has been updated.")
                println("Company have been saved.")
                
            }
        

        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
