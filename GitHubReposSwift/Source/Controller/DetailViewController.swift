//
//  DetailViewController.swift
//  GitHubReposSwift
//  Created by Juraj Hilje on 06/11/14.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var webView: UIWebView?
    var webURL: String?
    
    // MARK: Load HTML
    
    func loadHTML(#urlString: String)
    {
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.GET(
            urlString,
            parameters: nil,
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    
                let datastring = NSString(data: responseObject! as NSData, encoding: NSUTF8StringEncoding)
                
                self.webView?.loadHTMLString(datastring, baseURL: NSURL(string: urlString))
            },
            failure:
            {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                
                println("Error: " + error.localizedDescription)
            }
        )
    }
    
    // MARK: View lifecycle
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.loadHTML(urlString: self.webURL!)
    }
}