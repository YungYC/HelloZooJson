//
//  MasterViewController.swift
//  HelloZooJson
//
//  Created by Duncan on 2016/2/20.
//  Copyright © 2016年 Duncan. All rights reserved.
//

import UIKit

let animalURL = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
let planetURL = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14")

class MasterViewController: UITableViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate{

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var dataArray = [AnyObject]()
    var url = animalURL
    var nameIndex = "A_Name_Ch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //導入網址  設定session及委任  啟動時重啟下載動作
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let dataTask = session.downloadTaskWithURL(url!)
        dataTask.resume()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let changURLBuutton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
        
        self.navigationItem.rightBarButtonItem = changURLBuutton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    func insertNewObject(sender: AnyObject) {
        //"+"按鈕動作
        if url == animalURL{
            url = planetURL
        }else{
            url = animalURL
        }
        if nameIndex == "A_Name_Ch"{
            nameIndex = "F_Name_Ch"
        }else{
            nameIndex = "A_Name_Ch"
        }
        //修改Title>>Problem
        //UINavigationItem(title:"abc")
        self.viewDidLoad()
        /*
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        */
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //繼承資料給下個畫面
                let object = dataArray[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.thisAnimalDic = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = dataArray[indexPath.row]
        cell.textLabel!.text = object[nameIndex] as? String
        //cell.textLabel?.text = dataArray[indexPath.row]["A_Name_Ch"] as? String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    //NSURLSession protocal
    //下載後資料處理  取出result中的results  用do-try-catch
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: .AllowFragments) as! [String:[String:AnyObject]]
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            self.tableView.reloadData()
        }catch{
            print("Error!")
        }
    }
    
}

