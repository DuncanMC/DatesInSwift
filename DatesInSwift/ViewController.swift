//
//  ViewController.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 4/16/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

func possessiveNumber(aNumber: Int) -> String
{
  let suffix: String
  switch (aNumber % 10)
  {
  case 0, 4...9:
    suffix = "th"
  case 1:
    suffix = "st"
  case 2:
    suffix = "nd"
  case 3:
    suffix = "rd"
  default:
    suffix = ""
  }
  return "\(aNumber)\(suffix)"
}
class ViewController: UIViewController
{
  var message: String = ""
    {
    didSet
    {
      messageLabel.text = message
    }
  }
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func pickerValueChanged(sender: AnyObject)
  {
    message = ""
  }
  

  let duncanCsBirthday = (month: 5, day: 18, year: 1963)
  let markCsBirthday = (month: 4, day: 17, year: 1959)
  let daveCsBirthay = (month: 1, day: 2, year: 1937)
  let colinCsBirtday = (month: 12, day: 14, year: 1994)
  
  @IBAction func handleOkButton(sender: AnyObject)
  {
    let prefix: String
    
    //I compare the mdy tuples for the dates so I can ignore the time and just compare dates.
    if datePicker.date.mdy() == NSDate().mdy()
    {
      prefix = "is"
    }
    else if datePicker.date > NSDate()
    {
      prefix = "will be"
    }
    else
    {
      prefix = "was"
    }
    
    let theMDY = datePicker.date.mdy()
    let date = NSString(format: "%02d/%02d/%04d", theMDY.month, theMDY.day, theMDY.year)
    switch theMDY
    {
    case (3, 15, _):
      message = "Beware the Ides of March"
      
    case (daveCsBirthay):
      message = "\(date) \(prefix) the day Dave Champney was born"
      
    case (daveCsBirthay.month, daveCsBirthay.day, let year) where year > daveCsBirthay.year:
      message = "\(date) \(prefix) Dave Champney's \(possessiveNumber(theMDY.year - daveCsBirthay.year)) birthday"
      
    case (markCsBirthday):
      message = "\(date) \(prefix) the day Mark Champney was born"
      
    case (4, 17, let year) where year > markCsBirthday.year:
      message = "\(date) \(prefix) Mark Champney's \(possessiveNumber(year - markCsBirthday.year)) birthday"
      
    case (duncanCsBirthday):
      message = "\(date) \(prefix) the day Duncan Champney was born"
      
    case (duncanCsBirthday.month, duncanCsBirthday.day, let year) where year > duncanCsBirthday.year:
      message = "\(date) \(prefix) Duncan Champney's \(possessiveNumber(year - duncanCsBirthday.year)) birthday"
      
    case (colinCsBirtday):
      message = "\(date) \(prefix) the day Colin Champney was born"
      
    case (colinCsBirtday.month, colinCsBirtday.day, let year) where year > colinCsBirtday.year:
      message = "\(date) \(prefix) Colin Champney's \(possessiveNumber(year - colinCsBirtday.year)) birthday"
      
    case (5, 1...15, let year):
      message = "\(date) \(prefix) in the first half of May, \(year)"
      
    case (5, 16...31, let year):
      message = "\(date) \(prefix) in the second half of May, \(year)"
      
    default:
      message = "The selected date \(prefix) \(date)"
    }
  }
}

