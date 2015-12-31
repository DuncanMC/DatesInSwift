//
//  DateExtensions.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 4/16/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

public typealias mdyTuple = (month: Int, day: Int, year: Int)

import UIKit



//-------------------------------------------------------------------------------------------------------
// MARK: - Global functions -
//-------------------------------------------------------------------------------------------------------

func date(mdy mdy: mdyTuple) ->NSDate?
{

  let components = NSDateComponents()
  components.year = mdy.year
  components.month = mdy.month
  components.day = mdy.day
  
  return DateUtils.gregorianCalendar.dateFromComponents(components)
}

//-------------------------------------------------------------

/**
This function calculates the number of days (number of midnights)
between an end date and a start date.
It is designed for use with the Gregorian calendar.

This function only works for days that are in the same era.
(both dates are AD or both dates are BC)

- parameter startDate:: NSDate - the starting date
- parameter endDate:: NSDate - the ending date

- returns: endDate.dayNumber - startDate.dayNumber
*/

func daysBetweenDates(startDate startDate: NSDate, endDate: NSDate) -> Int
{
  return endDate.dayNumber() - startDate.dayNumber()
}


//-------------------------------------------------------------
// MARK: Function to allow matching mdy tuple constants in switch statements

func ~=(a: mdyTuple, b: mdyTuple) -> Bool {
  return a.month ~= b.month && a.year ~= b.year && a.day ~= b.day
}

//-------------------------------------------------------------
// MARK: This function makes it possible to compare mdyTuple objects using ==

public func ==(lhs: mdyTuple, rhs: mdyTuple) -> Bool
{
  return lhs.month == rhs.month &&
  lhs.day == rhs.day &&
  lhs.year == rhs.year
}

//-------------------------------------------------------------------------------------------------------
// MARK: - NSDate Equatable and Comparable extensions -
//-------------------------------------------------------------------------------------------------------
//Tell the system that NSDates can be compared with ==, >, >=, <, and <= operators

//extension NSDate: Equatable {}
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

//-------------------------------------------------------------------------------------------------------
// MARK: - other NSDate extensions -
//-------------------------------------------------------------------------------------------------------

extension NSDate
{
  /**
  This function returns a tuple containing the month, 
  day and year of the receiver
  
  - returns: typealias mdyTuple = (month: Int, day: Int, year: Int)
*/
  
  func mdy() -> mdyTuple
  {
    let calendar = DateUtils.gregorianCalendar
    
    //get the month/day/year componentsfor today's date.
    let date_components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day],
      fromDate: self)

    return (date_components.month, date_components.day, date_components.year)
  }
  
  /**
  This function calcuates an ordinal day number for the receiver 
  using the Gregorian calendar.
  
  - returns: an integer day number
  */
  
  func dayNumber() -> Int
  {
    let calendar = DateUtils.gregorianCalendar
    return calendar.ordinalityOfUnit(NSCalendarUnit.Day,
      inUnit: NSCalendarUnit.Era, forDate: self)
  }
}

//-------------------------------------------------------------------------------------------------------
// MARK: - DateUtils class -
//-------------------------------------------------------------------------------------------------------

//
/**
  :class:   DateUtils
  The sole purpose of the DateUtils class is to hold a static instance of a gregorian NSCalendar
  So that the other methods in this library don't have to create and destroy a calendar on each invocation
*/
class DateUtils
{
  static let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
}
