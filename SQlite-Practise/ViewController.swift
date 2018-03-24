//
//  ViewController.swift
//  SQlite-Practise
//
//  Created by MySoftheaven BD on 24/3/18.
//  Copyright © 2018 MySoftheaven BD. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var heroNameOutlet: UITextField!
    @IBOutlet weak var powerRankOutlet: UITextField!
    @IBOutlet weak var heroTableViewOutlet: UITableView!
    
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
        var db : OpaquePointer?
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database.")
            return
        }
        
        self.createTable(db: db)
        
        
        
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
        let queryString = "INSERT INTO heros"
    }
    
    func createTable(db : OpaquePointer?) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



