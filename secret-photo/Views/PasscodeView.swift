//
//  PasscodeView.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/6/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//
// Inpiration taken from https://github.com/acani/CodeInputView but modified to
// do dynamic sizing, show border boxes, work for multiple passcode lengths,
// and not show password digits

import UIKit

open class PasscodeView: UIView, UIKeyInput {
    open var delegate: PasscodeViewDelegate?
    var passcodeLength = 4
    private var currentDigit = 1
    private var codeEntered = ""
    
    open override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // default sizing
        var digitWidth = frame.width / CGFloat(passcodeLength)
        var spaceBetweenDigits: CGFloat = 0.0
        
        // add spacing if there is enough room
        if (frame.width >= CGFloat(passcodeLength * 50)) {
            spaceBetweenDigits = 15.0
            // account for spacing before first digit and after last
            let totalSpacingWidth = spaceBetweenDigits * CGFloat(passcodeLength + 1)
            let totalDigitWidth = frame.width - totalSpacingWidth
            digitWidth = totalDigitWidth / CGFloat(passcodeLength)
        }
        
        // Create labels
        let minDimension: CGFloat = (digitWidth > frame.height) ? frame.height : digitWidth
        var labelRect = CGRect(x: spaceBetweenDigits, y: 0, width: digitWidth, height: frame.height)
        for digitNum in 1...passcodeLength {
            let digitLabel = UILabel(frame: labelRect)
            digitLabel.font = .systemFont(ofSize: minDimension) // make sure text fits
            digitLabel.tag = digitNum
            digitLabel.backgroundColor = UIColor.white
            digitLabel.layer.borderWidth = 2
            digitLabel.layer.borderColor = UIColor.black.cgColor
            digitLabel.textAlignment = .center
            addSubview(digitLabel)
            labelRect.origin.x += digitWidth + spaceBetweenDigits
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var hasText: Bool {
        return currentDigit > 1
    }
    
    open func insertText(_ text: String) {
        (viewWithTag(currentDigit)! as! UILabel).text = "\u{2022}"
        codeEntered += text
        currentDigit += 1
        
        if currentDigit > passcodeLength {
            
            delegate?.passcodeView(self, finishedWithPasscode: codeEntered)
        }
    }
    
    open func deleteBackward() {
        if currentDigit > 1 {
            codeEntered = String(codeEntered.dropLast())
            currentDigit -= 1
            (viewWithTag(currentDigit)! as! UILabel).text = ""
        }
    }
    
    open func clear() {
        while currentDigit > 1 {
            deleteBackward()
        }
    }
    
    open var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}

public protocol PasscodeViewDelegate {
    func passcodeView(_ passcodeView: PasscodeView, finishedWithPasscode passcode: String)
}
