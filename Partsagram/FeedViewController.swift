//
//  FeedViewController.swift
//  Partsagram
//
//  Created by Maaz Adil on 9/30/20.
//  Copyright © 2020 Maaz Adil. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
            let query = PFQuery(className:"Posts")
            query.includeKey("author")
           query.includeKey("comments")
        query.includeKey("comments.author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
        let post = posts[section] //
        let user = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []  //grab the commetns and tel what it is
        let name = (user["firstName"] as? [PFObject]) ?? []
        return comments.count + 1
    }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return posts.count
        }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
       
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.nameLabel.text = comment["text"] as! String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user["name"] as! String
            
            return cell
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row] //row that you select is the indexpath and that is the post
        let comment = PFObject(className: "Comments") //create comment as pfobject in class COments
        comment["text"] = "This is a random comment"
        comment["post"] = post //want comment to know what post it belongs to
        comment["author"] = PFUser.current()! // who made the comment
        
        post.add(comment, forKey: "comments") //every post should have arrray of comments to which we add this comment
        
        post.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut() //clear Parse cache
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate: SceneDelegate = (scene?.delegate as? SceneDelegate)
        {
            delegate.window?.rootViewController = loginViewController
        }
        
      // let delegate = UIApplication.shared.delegate as! AppDelegate
       // delegate.window?.rootViewController = loginViewController
    }
    

}
