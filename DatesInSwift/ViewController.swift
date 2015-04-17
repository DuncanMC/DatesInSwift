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
  
  let bobsBirthday =    (month: 11, day: 30, year: 1961)
  let janesBirthday =   (month: 10, day: 14, year: 1987)
  let fredsBirthday =   (month: 4, day: 3, year: 1973)
  let patsBirthday =    (month: 7, day: 7, year: 1931)
  let susansBirthday =  (month: 3, day: 8, year: 1933)
    
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
    let todayMDY = NSDate().mdy()
    let theMDY = datePicker.date.mdy()
    let date = NSString(format: "%02d/%02d/%04d", theMDY.month, theMDY.day, theMDY.year)
    switch theMDY
    {
    case (3, 15, _):
      message = "Beware the Ides of March"
      
    case (fredsBirthday):
      message = "\(date) \(prefix) the day Fred was born"
      
    case (fredsBirthday.month, fredsBirthday.day, let year) where year > fredsBirthday.year:
      message = "\(date) \(prefix) Fred's \(possessiveNumber(theMDY.year - fredsBirthday.year)) birthday"
      
    case (janesBirthday):
      message = "\(date) \(prefix) the day Jane was born"
      
    case (janesBirthday.month, janesBirthday.day, let year) where year > janesBirthday.year:
      message = "\(date) \(prefix) Jane's \(possessiveNumber(year - janesBirthday.year)) birthday"
      
    case (bobsBirthday):
      message = "\(date) \(prefix) the day Bob was born"
      
    case (bobsBirthday.month, bobsBirthday.day, let year) where year > bobsBirthday.year:
      message = "\(date) \(prefix) Bob's \(possessiveNumber(year - bobsBirthday.year)) birthday"
      
    case (patsBirthday):
      message = "\(date) \(prefix) the day Pat was born"
      
    case (patsBirthday.month, patsBirthday.day, let year) where year > patsBirthday.year:
      message = "\(date) \(prefix) Pat's \(possessiveNumber(year - patsBirthday.year)) birthday"

    case (susansBirthday):
      message = "\(date) \(prefix) the day Susan was born"
      
    case (susansBirthday.month, susansBirthday.day, let year) where year > susansBirthday.year:
      message = "\(date) \(prefix) Susan \(possessiveNumber(year - susansBirthday.year)) birthday"

    case (5, 1...15, let year):
      message = "\(date) \(prefix) in the first half of May, \(year)"
      
    case (5, 16...31, let year):
      message = "\(date) \(prefix) in the second half of May, \(year)"
      
    case todayMDY:
      message = "Today is \(date)"
      
    case (4, _, _):
      message = "April showers bring May flowers"
      
    default:
      message = "The selected date \(prefix) \(date)"
    }
  }
}

