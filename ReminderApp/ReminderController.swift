//
//  ReminderController.swift
//  ReminderApp
//
//  Created by Hanyuan Li on 8/1/18.
//  Copyright © 2018 Qwerp-Derp. All rights reserved.
//

import UIKit
import CoreData

class ReminderController: UITableViewController {
    var reminders: [NSManagedObject] = []
    var alertController = UIAlertController()

    private func initReminders() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")

        do {
            self.reminders = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        initReminders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ReminderCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderCell else {
            fatalError("Dequeued cell is not a ReminderCell")
        }

        let reminder = reminders[indexPath.row]
        cell.reminderLabel.text = reminder.value(forKeyPath: "rdescription") as? String

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    @objc private func textFieldChanged(sender: UITextField) {
        self.alertController.actions[0].isEnabled = sender.text!.count > 0
    }

    private func saveReminder(_ description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedContext)!

        let reminder = NSManagedObject(entity: entity, insertInto: managedContext)
        reminder.setValue(description, forKey: "rdescription")

        do {
            try managedContext.save()
            self.reminders.append(reminder)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Actions
    @IBAction func addReminder(_ sender: Any) {
        self.alertController = UIAlertController(title: "New Reminder", message: "Enter reminder description:", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            let reminder = self.alertController.textFields?[0].text
            let newIndexPath = IndexPath(row: self.reminders.count, section: 0)

            self.saveReminder(reminder!)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        self.alertController.addTextField() { textField in
            textField.placeholder = "Description"
            textField.addTarget(self, action: #selector(self.textFieldChanged(sender:)), for: .editingChanged)
        }
        
        confirmAction.isEnabled = false

        self.alertController.addAction(confirmAction)
        self.alertController.addAction(cancelAction)

        self.present(self.alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
