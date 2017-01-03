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
      var RTF_Filename: String?
        {
        didSet(newValue)
        {
          //If the RTF_Filename is nil or the empty string, don't do anything
          if ((RTF_Filename ?? "").isEmpty)
          {
            return
          }
          //Use optional binding to try to get an URL to the
          //specified filename in the app bundle. If that succeeds, try to load
          //NSData from the file.
          if let fileURL = Bundle.main.url(forResource: RTF_Filename, withExtension: "rtf"),
            
            //If the fileURL loads, also try to load NSData from the URL.
            let theData = try? Data(contentsOf: fileURL)
          {
            var aString:NSAttributedString
            do
            {
              //Try to load an NSAttributedString from the data
              try
                aString = NSAttributedString(data: theData,
                  options: [:],
                  documentAttributes:  nil
              )
              //If it succeeds, install the attributed string into the field.
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
