//
//  DetailViewController.swift
//  HelloZooJson
//
//  Created by Duncan on 2016/2/20.
//  Copyright © 2016年 Duncan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var thisAnimalDic: AnyObject?
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //if有圖片就取  沒有則不動作
        let url = (thisAnimalDic as! [String:AnyObject])["A_Pic01_URL"]
        if let url = url {
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            let dataTask = session.downloadTaskWithURL(NSURL(string: url as! String)!)
            dataTask.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        guard let imageData = NSData(contentsOfURL: location) else{
            return
        }
        imageView.image = UIImage(data: imageData)
    }
}
