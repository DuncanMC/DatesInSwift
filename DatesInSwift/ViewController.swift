//
//  ViewController.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 4/16/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

//-------------------------------------------------------------------------------------------------------
// MARK: - Global functions -
//-------------------------------------------------------------------------------------------------------
/**
  This function returns a possessive form for a number,
  e.g. 1st for 1 or 3rd for 3.description

  - parameter aNumber: Int - the number to convert.

  - returns: a string containing the possessive form
*/
func possessiveNumber(_ aNumber: Int) -> String {
  let suffix: String
  if aNumber % 20 >= 11 &&  aNumber % 100 <= 19 {
    suffix = "th"
  } else {
  switch aNumber % 10 {
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
    }}
  return "\(aNumber)\(suffix)"
}

//-------------------------------------------------------------------------------------------------------
// MARK: - ViewController class  -
//-------------------------------------------------------------------------------------------------------
class ViewController: UIViewController {
  @objc var selectDateObsever: NSObjectProtocol?
  //-------------------------------------------------------------
  // - MARK: - IBOutlets
  //-------------------------------------------------------------
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var datesField: UITextView!
  //-------------------------------------------------------------
  // - MARK: - Instance variables
  //-------------------------------------------------------------
  @objc var message: String = ""
    {
    didSet
    {
      messageLabel.text = message
    }
  }
  
  @objc func setupObservers()
  {
    let notificationCenter = NotificationCenter.default

    selectDateObsever = notificationCenter.addObserver(
      forName: NSNotification.Name(rawValue: WTNotifications.selectDate),
      object: nil,
      queue: nil,
      using:
      {
        (note: Notification) -> Void in
        if let userInfo = (note as NSNotification).userInfo,
          let year = userInfo[SelectNoticeKeys.year] as? Int,
          let month = userInfo[SelectNoticeKeys.month] as? Int,
          let day = userInfo[SelectNoticeKeys.day] as? Int
        {
          let mdy = mdyTuple(month: month, day: day, year: year)
          if let dateFromURL = date(mdy: mdy)
          {
            self.datePicker.date = dateFromURL as Date
            self.handleOkButton(self)
          }
        }
    }
    )
  }

  //-------------------------------------------------------------------------------------------------------
  // MARK: - Init method -
  //-------------------------------------------------------------------------------------------------------

required  init?(coder: NSCoder)
  {
    super.init(coder: coder)
    setupObservers()  //register for notifications to move the picker to a new date.
  }
  //-------------------------------------------------------------------------------------------------------
  // MARK: - UIViewController methods -
  //-------------------------------------------------------------------------------------------------------
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    /*
    If we can load a file called "Dates.data" from the bundle and convert it to an attributed string,
    install it in the dates field. The contents contain clickable links with custom URLS to select
    each date.
    */
//    if
//      let datesPath = NSBundle.mainBundle().pathForResource("Dates", ofType: "data"),
//      let datesString = NSKeyedUnarchiver.unarchiveObjectWithFile(datesPath) as? NSAttributedString
//    {
//      datesField.attributedText = datesString
//    }
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBAction methods -
  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func pickerValueChanged(_ sender: AnyObject)
  {
    message = ""
  }
  
  @IBAction func handleOkButton(_ sender: AnyObject)
  {

    let bobsBirthday =    (month: 11, day: 30, year: 1961)
    let janesBirthday =   (month: 10, day: 14, year: 1987)
    let fredsBirthday =   (month: 4, day: 3, year: 1973)
    let patsBirthday =    (month: 7, day: 7, year: 1931)
    let susansBirthday =  (month: 3, day: 8, year: 1933)
    
    //Prefix will be used to build date sentences.
    //Is the user-selected date in the past, present, or future?
    let prefix: String
    
    let today = Date()
    
    let daysFromSelectedDayToToday = datePicker.date.dayNumber() - today.dayNumber()
    if daysFromSelectedDayToToday == 0
    {
      prefix = "is"
    }
    else if daysFromSelectedDayToToday > 0
    {
      prefix = "will be"
    }
    else
    {
      prefix = "was"
    }
    
    let todayMDY = Date().mdy()
    let theMDY = datePicker.date.mdy()
    let date = NSString(format: "%02d/%02d/%04d", theMDY.month, theMDY.day, theMDY.year)
    
    //The cases are evaluated top-to-bottom. 
    //The code of first match is executed, then processing stops.
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
      message = "\(date) \(prefix) Susan's \(possessiveNumber(year - susansBirthday.year)) birthday"
      
    //Match the month, day range 1...15, and copy the year to a constant.
    case (5, 1...15, let year):
      message = "\(date) \(prefix) in the first half of May, \(year)"
      
    case (5, 16...31, let year):
      message = "\(date) \(prefix) in the second half of May, \(year)"
      
    //Match the month, copy the day value to a constant, and match any year.
    case (2, let day, _)
      where day % 2 == 0:     //The optional where clause is a boolean expression which must be true
                              //for the case to match
      message = "\(date) \(prefix) an even day in February"
      
    case (2, let day, _) where day % 2 == 1:
      message = "\(date) \(prefix) an odd day in February"
      
    case todayMDY:
      message = "Today is \(date)"
      
    //Match Any day in april, any year.
    case (4, _, _):
      message = "April showers bring May flowers"
      
    default:
      message = "The selected date \(prefix) \(date)"
    }
  }
  
  @objc func textView(_ textView: UITextView,
    shouldInteractWithURL URL: Foundation.URL,
    inRange characterRange: NSRange) -> Bool
  {
    return true
  }
}

