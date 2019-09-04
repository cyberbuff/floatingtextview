//
//  ViewController.swift
//  FloatingTextView
//
//  Created by Hare Sudhan on 06/01/18.
//  Copyright © 2018 Hare Sudhan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(ZMTextViewCell.self, forCellReuseIdentifier: "ZMTextViewCell")
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZMTextViewCell", for: indexPath) as? ZMTextViewCell ?? ZMTextViewCell(style: .default, reuseIdentifier: "ZMTextViewCell")
        cell.textView.delegate = self
        cell.selectionStyle = .none
        cell.textView.setText()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        
    }
    
}

