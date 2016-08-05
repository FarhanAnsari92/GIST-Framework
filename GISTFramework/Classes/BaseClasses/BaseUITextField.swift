//
//  BaseTextField.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

public class BaseUITextField: UITextField, UITextFieldDelegate, BaseView {
   
    @IBInspectable public var sizeForIPad:Bool = false;
    
    @IBInspectable public var bgColorStyle:String? = nil {
        didSet {
            self.backgroundColor = SyncedColors.color(forKey: bgColorStyle);
        }
    }
    
    @IBInspectable public var boarder:Int = 0 {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var boarderColorStyle:String? = nil {
        didSet {
            if let boarderCStyle:String = boarderColorStyle {
                self.addBorder(SyncedColors.color(forKey: boarderCStyle), width: boarder)
            }
        }
    }
    
    @IBInspectable public var cornerRadius:Int = 0 {
        didSet {
            self.addRoundedCorners(UIView.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
    }
    
    @IBInspectable public var rounded:Bool = false {
        didSet {
            if rounded {
                self.addRoundedCorners();
            }
        }
    }
    
    @IBInspectable public var hasDropShadow:Bool = false {
        didSet {
            if (hasDropShadow) {
                self.addDropShadow();
            } else {
                // TO HANDLER
            }
        }
    }
    
    @IBInspectable public var fontName:String = "fontRegular" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontStyle:String = "medium" {
        didSet {
            self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        }
    }
    
    @IBInspectable public var fontColorStyle:String? = nil {
        didSet {
            self.textColor = SyncedColors.color(forKey: fontColorStyle);
        }
    }
    
    @IBInspectable public var placeholderColor:String? = nil {
        didSet {
            if let colorStyl:String = placeholderColor {
                if let plcHolder:String = self.placeholder {
                    self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
                }
            }
        }
    } //P.E.
    
    @IBInspectable public var verticalPadding:CGFloat=0
    @IBInspectable public var horizontalPadding:CGFloat=0
    
    private var _maxCharLimit: Int = 50;
    @IBInspectable public var maxCharLimit: Int {
        get {
            return _maxCharLimit;
        }
        
        set {
            if (_maxCharLimit != newValue)
            {_maxCharLimit = newValue;}
        }
    } //P.E.
    
    //Maintainig Own delegate
    private weak var _delegate:UITextFieldDelegate?;
    public override weak var delegate: UITextFieldDelegate? {
        get {
            return _delegate;
        }
        
        set {
            _delegate = newValue;
        }
    } //P.E.
    
    private var _placeholderKey:String?
    override public var placeholder: String? {
        get {
            return super.placeholder;
        }
        
        set {
            if let key:String = newValue where key.hasPrefix("#") == true {
                _placeholderKey = key; // holding key for using later
                
                if let plcHolder:String = SyncedText.text(forKey: key) {
                    if let colorStyl:String = placeholderColor {
                        self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSForegroundColorAttributeName: SyncedColors.color(forKey: colorStyl)!]);
                    } else {
                        super.placeholder = plcHolder;
                    }
                } else {
                    super.placeholder = nil;
                }
            } else {
                super.placeholder = newValue;
            }
        }
    } //P.E.
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        //--
        self.commonInit();
    } //C.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //--
        commonInit();
    } //F.E.
    
    private func commonInit() {
        super.delegate = self;
        //--
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let placeHoldertxt:String = self.placeholder where placeHoldertxt.hasPrefix("#") == true{
            self.placeholder = placeHoldertxt; // Assigning again to set value from synced data
        }
    } //F.E.
    
    public func updateView() {
        
        self.font = UIFont.font(fontName, fontStyle: fontStyle, sizedForIPad: self.sizeForIPad);
        
        if let bgCStyle:String = self.bgColorStyle {
            self.bgColorStyle = bgCStyle;
        }
        
        if let boarderCStyle:String = self.boarderColorStyle {
            self.boarderColorStyle = boarderCStyle;
        }
        
        if let fntClrStyle = self.fontColorStyle {
            self.fontColorStyle = fntClrStyle;
        }

        if let placeHolderKey:String = _placeholderKey {
            self.placeholder = placeHolderKey;
        }
        
        /*
        if let txt:String = self.text where txt.hasPrefix("#") == true {
            self.text = txt; // Assigning again to set value from synced data
        }
        */
    } //F.E.
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        //??super.textRectForBounds(bounds)
       
        let x:CGFloat = bounds.origin.x + horizontalPadding
        let y:CGFloat = bounds.origin.y + verticalPadding
        let widht:CGFloat = bounds.size.width - (horizontalPadding * 2)
        let height:CGFloat = bounds.size.height - (verticalPadding * 2)
        
        return CGRectMake(x,y,widht,height)
    } //F.E.
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        super.editingRectForBounds(bounds)
        return self.textRectForBounds(bounds)
    } //F.E.
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true;
    } //F.E.
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField);
    } //F.E.
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldEndEditing?(textField) ?? true;
    } //F.E.
    
    public func textFieldDidEndEditing(textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField);
    } //F.E.
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let rtn = _delegate?.textField?(textField, shouldChangeCharactersInRange:range, replacementString:string) ?? true;
        
        //IF CHARACTERS-LIMIT <= ZERO, MEANS NO RESTRICTIONS ARE APPLIED
        if (self.maxCharLimit <= 0) {
            return rtn;
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return (newLength <= self.maxCharLimit) && rtn // Bool
    } //F.E.
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true;
    } //F.E.
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true;
    } //F.E.
    
} //CLS END
