//
//  ViewController.swift
//  SQlite-Practise
//
//  Created by MySoftheaven BD on 24/3/18.
//  Copyright © 2018 MySoftheaven BD. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var heroNameOutlet: UITextField!
    @IBOutlet weak var powerRankOutlet: UITextField!
    @IBOutlet weak var heroTableViewOutlet: UITableView!
    
    var db : OpaquePointer?
    
    var heroList = [Hero]()
    
    let createTableString = """
        CREATE TABLE IF NOT EXISTS HEROES (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            powerrank INTEGER
        );
        """

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HerosDatabase.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database.")
            return
        }
        
        self.createTable()
        readValues()
        self.heroTableViewOutlet.reloadData()
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let hero:Hero
        hero = heroList[indexPath.row]
        cell.textLabel?.text = "\(hero.name!)    || \(hero.powerrank)"
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        //getting value from textfields
        let name = heroNameOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let powerrank = powerRankOutlet.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //validating the values are not empty
        if (name?.isEmpty)! {
            heroNameOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if (powerrank?.isEmpty)! {
            powerRankOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        //creating a statement
        var insertStatement : OpaquePointer? = nil
        
        //insert query
        let insertQueryString = "INSERT INTO HEROES (name, powerrank)  VALUES(? , ?)"
        
        //preparing the query
        if sqlite3_prepare_v2(db, insertQueryString, -1, &insertStatement, nil) != SQLITE_OK {
            print("Error preparing insert query.")
            return
        }
        
        //binding the parameter
        if sqlite3_bind_text(insertStatement, 1, name, -1, nil) != SQLITE_OK {
            print("failure to bind ")
            return
        }
        
        if sqlite3_bind_int(insertStatement, 2, (powerrank! as NSString).intValue) != SQLITE_OK {
            print("failure to bind")
            return
        }
        
        //executing the query
        if sqlite3_step(insertStatement) != SQLITE_DONE {
            print("insertion failed")
            return
        }
        
        //emptying the textfields
        heroNameOutlet.text = ""
        powerRankOutlet.text = ""
        
        print("hero saved successfully")
        self.readValues()
        self.heroTableViewOutlet.reloadData()
        
    }
    
    func createTable() {
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("table successfully created.")
            }
            else {
                print("table could not be created.")
            }
        } else {
            print("table statement could not be created.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func readValues() {
        //first empty the array of Heros
        heroList.removeAll()
        
        //query string
        let selectQueryString = "SELECT * FROM HEROES"
        
        //statement pointer
        var selectQueryStatement : OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare_v2(db, selectQueryString, -1, &selectQueryStatement, nil) != SQLITE_OK {
            print("query can not be created")
            return
        }
        
        // traversing thorough all the records
        while sqlite3_step(selectQueryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(selectQueryStatement, 0)
            let name = String(cString: sqlite3_column_text(selectQueryStatement, 1))
            let powerRank = sqlite3_column_int(selectQueryStatement, 2)
            print(powerRank)
            heroList.append(Hero(id: Int(id), name: name, powerrank: Int(powerRank)))
            
        }
    }

    


}



