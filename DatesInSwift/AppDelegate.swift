//
//  AppDelegate.swift
//  DatesInSwift
//
//  Created by Duncan Champney on 4/16/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
  {
    
    //Code to generate random mm/dd/yyyy dates from Jan 1, 1930 to Dec 1, 2002
    /*
    let startSeconds = round(date(mdy: (1, 1, 1930))!.timeIntervalSinceReferenceDate)
    
    let endSeconds = round(date(mdy: (12, 1, 2002))!.timeIntervalSinceReferenceDate)
    
    let range = UInt32(round(endSeconds - startSeconds))
    
    for _ in 1...5
    {
    let dateDouble = Double(arc4random_uniform(range))  + startSeconds;
    let theMDY = NSDate(timeIntervalSinceReferenceDate:  dateDouble).mdy()
    let dateString = NSString(format: "%02d/%02d/%04d", theMDY.month, theMDY.day, theMDY.year)
    println("Random date = \(dateString)")
    }
    */
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  
  /*
  This app supports the custom URL scheme `WTDateLink://`. A typical URL is of the form:
  WTDateLink://?date=MM_DD_YYYY or WTDateLink://?date=today.
  
  If we can parse a valid date, we broadcast a notification with the components of the date.
  The app's (only) view controller registers for that notification and uses it to switch the picker to the date.
  
  The app's view controller presents a UITextView that loads the encoded content of an RTF file including links using the WTDateLink:// prefix. Tapping one of those links triggers this method, which sends a notifcation to the view controller.
  */
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool
  {
    var infoDictionary: [NSObject : AnyObject]?
    
    //An URL's "query" is everthing after the "?" (should be the "date=..." bit for our URLs)
    if
      let theQuery = url.query?.lowercaseString,
      let range = theQuery.rangeOfString("date=")
    {
      let dateString = theQuery.substringFromIndex(range.endIndex)
      
      //if the dateString is "today", create an
      //infoDictonary with the components of today's date.
      if dateString == "today"
      {
        let todayMDY = NSDate().mdy()
        infoDictionary = [
          SelectNoticeKeys.month: todayMDY.month,
          SelectNoticeKeys.day:   todayMDY.day,
          SelectNoticeKeys.year:  todayMDY.year];
      }
        //Otherwise, try to parse a string in the form MM_DD_YYYY
      else
      {
        let components = dateString.componentsSeparatedByString("_")
        if components.count == 3
        {
          if let month = (components[0] as String).toInt(),
            day = (components[1] as String).toInt(),
            year = (components[2] as String).toInt()
          {
            if month != 0 && day != 0 && year != 0
            {
              //Build an infoDictionary containing the values from the URL
              infoDictionary = [
                SelectNoticeKeys.month: month,
                SelectNoticeKeys.day:   day,
                SelectNoticeKeys.year:  year]
            }
          }
        }
      }
    }
    //If we were able to build an infoDictionary,
    //post a notification to the NSNotificationCenter.
    if infoDictionary != nil
    {
      NSNotificationCenter.defaultCenter().postNotificationName(
        WTNotifications.selectDate,
        object: nil,
        userInfo: infoDictionary
      )
      return true
    }
    else
    {
      return false
    }
  }
}
