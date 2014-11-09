//
//  ListViewController.swift
//  GitHubReposSwift
//  Created by Juraj Hilje on 06/11/14.
//

import UIKit

class ListViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource
{
    let k_JSON_URL: String = "https://api.github.com/users/jurajhilje/repos"
    let k_VIEW_TITLE: String = "GitHub Repos"
    let k_ROW_HEIGHT: CGFloat = 70.0
    
    var repos = Array<Repo>()
    var selectedRepo: Repo?
    var loadJSONFlag: Bool?
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {
        if (segue?.identifier == "detailViewFromList")
        {
            let dvc = segue?.destinationViewController as DetailViewController
            
            dvc.title = self.selectedRepo?.name
            dvc.webURL = self.selectedRepo?.htmlURL
        }
    }
    
    // MARK: Load and parse JSON
    
    func refreshData()
    {
        self.loadJSONWithUrlString(urlString: self.k_JSON_URL)
    }
    
    func loadJSONWithUrlString(urlString url: String)
    {
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(
            url,
            parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                self.parseData(responseObject: responseObject)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                
                println("Error: " + error.localizedDescription)
                
                self.refreshControl?.endRefreshing()
            }
        )
    }
    
    func parseData(#responseObject: AnyObject)
    {
        let json = JSON(responseObject)
        
        self.repos.removeAll()
        
        for (key: String, subJson: JSON) in json
        {
            let tempRepo = Repo()
            
            tempRepo.fullName = subJson["full_name"].stringValue
            tempRepo.name = subJson["name"].stringValue
            tempRepo.htmlURL = subJson["html_url"].stringValue
            tempRepo.avatarURL = subJson["owner"]["avatar_url"].stringValue
            
            self.repos.append(tempRepo)
        }
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.repos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let repo: Repo = self.repos[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as ListCell
        
        cell.titleLabel?.text = repo.fullName
        cell.detailLabel?.text = repo.htmlURL
        cell.thumbImageView?.setImageWithURL(NSURL(string: repo.avatarURL!))
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.selectedRepo = self.repos[indexPath.row]
        
        self.performSegueWithIdentifier("detailViewFromList", sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.k_ROW_HEIGHT;
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = self.k_VIEW_TITLE
        
        self.tableView.rowHeight = k_ROW_HEIGHT
        
        self.refreshControl?.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        
        self.loadJSONFlag = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if self.loadJSONFlag == true
        {
            self.refreshData()
        }
    }
}