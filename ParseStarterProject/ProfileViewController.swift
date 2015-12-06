//
//  ProfileViewController.swift
//  
//
//  Created by Rizen Yamauchi on 11/9/15.
//
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var material: UITextField!
    @IBOutlet weak var color: UITextField!
    @IBOutlet weak var shirtSize: UITextField!
    @IBOutlet weak var season: UITextField!
    @IBOutlet weak var budget: UITextField!
    
    
    
    
    
    
    
    @IBOutlet weak var profilePic: UIImageView!

    @IBAction func addProfilePicture(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        profilePic.image = image
        
        let imageData: NSData = UIImagePNGRepresentation(profilePic.image)
        let imageFile: PFFile = PFFile(name:"image.png", data:imageData)
        imageFile.save()
        
        let user = PFUser.currentUser()
        user!.setObject(imageFile, forKey: "profilePicture")
        user?.saveInBackground()
        
        
    }
    
    
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
           // self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func SaveSizes(sender: AnyObject) {
        
        if (shirtSize.text == "" || brandName.text == "" || material.text == "" || color.text == "" || season.text == "" || budget.text == ""  ){
            
            displayAlert("Error in form", message: "Please enter all the information")
            
        }
        else{
            var currentUser = PFObject(className: "Preference")
                currentUser["Name"] = PFUser.currentUser()!.objectId!
                currentUser["shirtSize"] = shirtSize.text
                currentUser["preferredBrand"] = brandName.text
                currentUser["preferredMaterial"] = material.text
                currentUser["budget"] = budget.text
                currentUser["favoriteColor"] = color.text
                currentUser["preferredSeason"] = season.text
            
                //set other fields the same way....
                currentUser.saveInBackground()
                
                displayAlert("Saved", message: "Your Preference has been updated.")
            
                println("User's Preferred Style has been updated.")
            

        }
        
    }
    
    
    
    
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Preference")
        var name = PFUser.currentUser()!.objectId!
        query.whereKey("Name", equalTo:name)
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if error == nil{
                if let objects = objects{
                    if name != ""{
                    for object in objects{
       
                        self.shirtSize.placeholder = object["shirtSize"] as! String?
                self.material.placeholder = object["preferredMaterial"] as! String?
               self.brandName.placeholder = object["preferredBrand"] as! String?
               self.color.placeholder = object["favoriteColor"] as! String?
               self.budget.placeholder =  object["budget"] as! String?
                self.season.placeholder = object["preferredSeason"] as! String?

                    }
                }
            }
            }
             else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        var query2 = PFUser.query()
        
        query2?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.messages.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        self.usernameLabel.text = user.username!
                        
                    }
                }
            }
            
            if let currentUser = PFUser.currentUser(){

                if (currentUser["profilePicture"] != nil){
                
                    
                let proPic: PFFile = currentUser["profilePicture"] as! PFFile
                proPic.getDataInBackgroundWithBlock(){
                    (ImageData, error)-> Void in
                    if error == nil {
                        let Image:UIImage = UIImage(data: ImageData!)!
                        self.profilePic.image = Image
                    }
                    }
                }
            }
            
        })
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
