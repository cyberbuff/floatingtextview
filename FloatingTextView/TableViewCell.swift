//
//  TableViewCell.swift
//  FloatingTextView
//
//  Created by Hare Sudhan on 06/01/18.
//  Copyright © 2018 Hare Sudhan. All rights reserved.
//

import UIKit

class ZMTextViewCell: UITableViewCell {
    
    var textView : ZMTextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup() {
        textView = ZMTextView()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 21))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}

