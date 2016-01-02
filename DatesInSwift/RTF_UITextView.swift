//
//  RTF_UITextView.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 1/1/16.
//  Copyright © 2016 Duncan Champney. All rights reserved.
//

import UIKit

@IBDesignable
class RTF_UITextView: UITextView
{
  @IBInspectable
  var RTF_Filename: String = ""
  {
    didSet(newValue)
    {
      print("filename = \(RTF_Filename)")
      if let fileURL = NSBundle.mainBundle().URLForResource(RTF_Filename, withExtension: "rtf"),
      let theData = NSData(contentsOfURL: fileURL)
      {
        var aString:NSAttributedString
        do {
          try
          aString = NSAttributedString(data: theData,
            options: [:],
            documentAttributes:  nil
          )
          self.attributedText = aString;
        }
        catch
        {
          print("Nerp.");
        }
      }
      
      }
    }
  }
