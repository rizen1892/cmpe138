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
    @IBOutlet weak var shirtSize: UITextField!
    @IBOutlet weak var PantSize: UITextField!
    @IBOutlet weak var ShoeSize: UITextField!
    
 
    
    @IBOutlet weak var profilePic: UIImageView!

    @IBAction func AddProfilePic(sender: AnyObject) {
    
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
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        PFUser.logOut()
        
        var currentUser = PFUser.currentUser()
        currentUser = nil
        if currentUser == nil {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    }
    
    
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
           // self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func SaveSizes(sender: AnyObject) {
        
        if (shirtSize.text == "" || PantSize.text == "" || ShoeSize.text == "" ){
            
            displayAlert("Error in form", message: "Please enter the sizes")
            
        }
        
        if let currentUser = PFUser.currentUser(){
            currentUser["shirtSize"] = shirtSize.text
            currentUser["pantSize"] = PantSize.text
            currentUser["shoeSize"] = ShoeSize.text
            
            //set other fields the same way....
            currentUser.saveInBackground()
            
            displayAlert("Saved", message: "Your information has been updated.")
            
        }
        
    }
    
    
    
    
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
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
                self.shirtSize.placeholder = currentUser["shirtSize"] as! String?
                self.PantSize.placeholder =  currentUser["pantSize"] as! String?
                self.ShoeSize.placeholder = currentUser["shoeSize"] as! String?

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
