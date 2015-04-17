//
//  DateExtensions.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 4/16/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

public typealias mdyTuple = (month: Int, day: Int, year: Int)

import UIKit

func date(#mdy: mdyTuple) ->NSDate?
{
  let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
  
  let components = NSDateComponents()
  components.year = mdy.year
  components.month = mdy.month
  components.day = mdy.day
  
  return calendar.dateFromComponents(components)
}
/**
  This function makes it possible to use mdyTuple constants or variables in the cases
 
of switch statements.
*/
func ~=(a: mdyTuple, b: mdyTuple) -> Bool {
  return a.month ~= b.month && a.year ~= b.year && a.day ~= b.day
}

/**
  This function makes it possible to compar mdyTuple objects using ==
*/
public func ==(lhs: mdyTuple, rhs: mdyTuple) -> Bool
{
  return lhs.month == rhs.month &&
  lhs.day == rhs.day &&
  lhs.year == rhs.year
}

//-------------------------------------------------------------
//Tell the system that NSDates can be compared with ==, >, >=, <, and <= operators
extension NSDate: Equatable {}
extension NSDate: Comparable {}

//-------------------------------------------------------------
//Define the global operators for the
//Equatable and Comparable protocols for comparing NSDates

public func ==(lhs: NSDate, rhs: NSDate) -> Bool
{
  return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool
{
  return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool
{
  return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
public func <=(lhs: NSDate, rhs: NSDate) -> Bool
{
  return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool
{
  return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
//-------------------------------------------------------------

extension NSDate
{
  /**
  This function returns a tuple containing the month, day and year of the receiver
  
  :returns: typealias mdyTuple = (month: Int, day: Int, year: Int)
*/
  func mdy() -> mdyTuple
  {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    //get the month/day/year componentsfor today's date.
    let date_components = calendar.components(
      NSCalendarUnit.CalendarUnitYear |
        NSCalendarUnit.CalendarUnitMonth |
        NSCalendarUnit.CalendarUnitDay,
      fromDate: self)
    

    return (date_components.month, date_components.day, date_components.year)
  }
}