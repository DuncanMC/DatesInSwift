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
  WTDateLink://?date=04_03_1973 or WTDateLink://?date=today.
  
  If we can parse a valid date, we broadcast a notification with the components of the date. 
  The app's view controller registers for that notification and uses it to switch the picker to the date.
  
  The app's view controller presents a UITextView that loads the encoded content of an RTF file including links using the WTDateLink:// prefix. Tapping one of those links triggers this method, which sends a notifcation to the view controller.
  */
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool
  {
    //An URL's "query" is everthing after the "?" (should be the "date=..." bit for our URLs)
    if let theQuery = url.query
    {
      let theQueryNSString = theQuery //as NSString
      let range = theQueryNSString.rangeOfString("date=")
      if range != nil
      {
        let dateString = theQueryNSString.substringFromIndex(range!.endIndex)
        var infoDictionary: [String: Int]?
        if dateString == "today"
        {
          let todayMDY = NSDate().mdy()
          infoDictionary = ["month": todayMDY.month,
            "day": todayMDY.day,
            "year": todayMDY.year];
        }
        else
        {
          let components = dateString.componentsSeparatedByString("_")
          if components.count == 3
          {
            if let month = (components[0] as String).toInt(),
              day = (components[1] as String).toInt(),
              year = (components[2] as String).toInt()
            {
              
              infoDictionary = ["month": month, "day": day, "year": year]
            }
          }
        }
        if let infoDictionary = infoDictionary
        {
          NSNotificationCenter.defaultCenter().postNotificationName("selectDate",
            object: nil, userInfo: infoDictionary  as [NSObject : AnyObject])
        }
      }
    }
    return true
  }
}

