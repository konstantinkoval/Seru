//
//  MasterViewController.swift
//  test111
//
//  Created by Konstantin Koval on 27/12/14.
//  Copyright (c) 2014 Konstantin Koval. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var stack: Storage!
  var objects: [NSManagedObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.leftBarButtonItem = self.editButtonItem()
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
    self.navigationItem.rightBarButtonItem = addButton
    reloadData()
  }

  func reloadData() {
    
    stack.performInMainContext { context in
      let fetch = NSFetchRequest(entityName: "Entity")
      var error: NSError?
      if let result = context.executeFetchRequest(fetch, error: &error) as? [NSManagedObject] {
        self.objects = result
        self.tableView.reloadData()
      }
    }
  }
  
  func insertNewObject(sender: AnyObject) {
    
    stack.performBackgroundSave({ context in
      var object = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context) as! NSManagedObject
      object.setValue(NSDate(), forKey: "time")
    
    },completion: { completed in
      self.reloadData()
    })
  }

  // MARK: - Table View

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
    self.configureCell(cell, atIndexPath: indexPath)
    return cell
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
  
      let objectID = (self.objects[indexPath.row] as NSManagedObject).objectID
      self.stack.performBackgroundSave({ (context: NSManagedObjectContext) in
        let object = context.objectWithID(objectID)
        context.deleteObject(object)
      }, completion: { result in
        self.reloadData()
      })
    }
  }

  func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    let object = objects[indexPath.row]
    cell.textLabel!.text = object.valueForKey("time")!.description
  }
}
