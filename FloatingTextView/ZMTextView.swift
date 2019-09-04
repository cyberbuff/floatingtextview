//
//  ZMTextView.swift
//  FloatingTextView
//
//  Created by Hare Sudhan on 06/01/18.
//  Copyright © 2018 Hare Sudhan. All rights reserved.
//

import Foundation
import UIKit

class ZMPlaceHolder : UITextField{
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth : CGFloat
        
        if let width = self.leftView?.frame.width{
            leftViewWidth = width + 5
        }else{
            leftViewWidth = 0
        }
        return CGRect(x: bounds.origin.x + leftViewWidth, y: bounds.origin.y + (self.font?.lineHeight ?? 0)/2, width: bounds.size.width - leftViewWidth, height: bounds.size.height - 16)
    }
}

class ZMTextView: UITextView {
    
    private var floatingPlaceHolder   : ZMPlaceHolder!
    
    private var showPlaceHolder       : Bool!
    private var leftPadding           : CGFloat  = 0
    private var floatingLabelYPadding : CGFloat  = 0
    
    private var defaultYPadding : CGFloat{
        get{
            return floatingPlaceHolderFont.lineHeight + 16
        }
    }
    
    internal override var intrinsicContentSize: CGSize{
        get{
            let textFieldIntrinsicContentSize = super.intrinsicContentSize
            
            if let str = self.text,str.count == 1, self.frame.height != textFieldIntrinsicContentSize.height{
                // Workaround - When we type the first character , the frame doesnt get adjusted.
                animationInterval = 0.3
                return CGSize(width: textFieldIntrinsicContentSize.width,
                              height: self.frame.height)
            }else if(showPlaceHolder == nil){ // Executes only for the first time
                animationInterval = 0 // Hides animation during start
                return CGSize(width: textFieldIntrinsicContentSize.width,
                              height: textFieldIntrinsicContentSize.height + self.floatingPlaceHolderFont.lineHeight + 4) // 4 - Bottom TextContainerInset
            }else{
                animationInterval = 0.3
                return textFieldIntrinsicContentSize;
            }
        }
    }
    
    //MARK:- Customizations
    var placeHolderTextColor         : UIColor  = UIColor.blue.withAlphaComponent(0.4)
    var floatingPlaceHolderTextColor : UIColor  = UIColor.gray.withAlphaComponent(0.65)
    
    var placeHolderFont         : UIFont       = UIFont.systemFont(ofSize: 16)
    var floatingPlaceHolderFont : UIFont       = UIFont.systemFont(ofSize: 12)
    
    var textViewFont            : UIFont       = UIFont.systemFont(ofSize: 16) {
        didSet{
            self.font = textViewFont
        }
    }
    
    private var animationInterval    : TimeInterval = 0.3
    
    var placeHolderText       : String! {
        didSet {
            floatingPlaceHolder.text = placeHolderText
        }
    }
    
    var placeHolderImage : UIImage! {
        didSet{
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.floatingPlaceHolderFont.lineHeight + 4, height: self.floatingPlaceHolderFont.lineHeight + 4))
            imageView.image = placeHolderImage.withRenderingMode(.alwaysTemplate)
            
            floatingPlaceHolder.leftViewMode = .always
            floatingPlaceHolder.leftView     = imageView
            
            leftPadding = (floatingPlaceHolder.leftView?.frame.width ?? 0) + 5
        }
    }
    
    
    //MARK:- Initializers
    public convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup(){
        placeHolderFont = textViewFont
        
        floatingPlaceHolder = ZMPlaceHolder(frame: self.frame)
        floatingPlaceHolder.isUserInteractionEnabled = false
        floatingPlaceHolder.textColor = floatingPlaceHolderTextColor
        floatingPlaceHolder.font      = placeHolderFont
        floatingPlaceHolder.tintColor = floatingPlaceHolderTextColor
        floatingPlaceHolder.backgroundColor = .white
        self.insertSubview(floatingPlaceHolder, at: 0)
        
        self.font = textViewFont
        self.textAlignment = NSTextAlignment.justified
        
        NotificationCenter.default.addObserver(self, selector: #selector(layoutSubviews), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(layoutSubviews), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(layoutSubviews), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
        
    }
    
    func setText(){
        let txt  = """
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
        """
        setValues(forPlaceHolder: "Description", textViewStr: txt)
    }
    
    func setValues(forPlaceHolder placeHolder: String,withPlaceHolderImage placeHolderImage : UIImage? = nil,textViewStr str : String){
        
        self.placeHolderText = placeHolder
        self.text = str
        
        if let image = placeHolderImage{
            self.placeHolderImage = image
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let showPlaceHolder = (self.text?.isEmpty ?? true)
        let placeHolderXPosition : CGFloat = 4
        
        self.floatingPlaceHolder.frame.size = CGSize(width:self.frame.width,height : self.defaultYPadding)
        
        if(self.showPlaceHolder != showPlaceHolder){ // Perform only when there is a transition from empty text to text and vice-versa
            self.showPlaceHolder = showPlaceHolder
            DispatchQueue.main.async {
                if(showPlaceHolder){
                    UIView.animate(withDuration: self.animationInterval, animations: {
                        self.floatingPlaceHolder.font      = self.placeHolderFont
                        self.floatingPlaceHolder.textColor = self.floatingPlaceHolderTextColor
                        self.floatingPlaceHolder.tintColor = self.floatingPlaceHolderTextColor
                        
                        self.floatingPlaceHolder.frame = CGRect(x: placeHolderXPosition, y: (self.frame.height - self.defaultYPadding)/2, width: self.frame.width, height: self.defaultYPadding)
                    })
                    
                    self.textContainerInset = UIEdgeInsets(top: (self.frame.height - self.defaultYPadding + self.placeHolderFont.lineHeight)/2, left: self.leftPadding, bottom: 0, right: 0)
                }else{
                    UIView.animate(withDuration: self.animationInterval, animations: {
                        self.floatingPlaceHolder.frame = CGRect(x: placeHolderXPosition, y: 0, width: self.frame.width, height: self.defaultYPadding)
                        self.floatingPlaceHolder.textColor = self.placeHolderTextColor
                        self.floatingPlaceHolder.tintColor = self.placeHolderTextColor
                        self.floatingPlaceHolder.font      = self.floatingPlaceHolderFont
                    })
                    
                    // If there is a placeholder image, add 2 px left padding , so that the text is aligned with the placeholder
                    
                    let leftPadding1 : CGFloat
                    if self.placeHolderImage != nil {
                        leftPadding1 = 2
                    }else{
                        leftPadding1 = 0
                    }
                    
                    self.textContainerInset = UIEdgeInsets(top: self.floatingPlaceHolder.frame.size.height + self.floatingLabelYPadding, left: leftPadding1, bottom: 4, right: 0)
                    
                }
            }
        }
    }
}
