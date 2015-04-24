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

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  /*
  This app supports the custom URL scheme `WTDateLink://`. A typical URL is of the form:
  WTDateLink://?date=04_03_1973 or WTDateLink://?date=today.
  
  If we can
  */
  func application(application: UIApplication,
    openURL url: NSURL,
    sourceApplication: String?,
    annotation: AnyObject?) -> Bool
  {
    println("opening URL \(url)")
    if let theQuery = url.query
    {
      let theQueryNSString = theQuery as NSString
      let range: NSRange = theQueryNSString.rangeOfString("date=")
      if range.location != NSNotFound
      {
        let start = range.location + range.length
        let range = NSRange(location: start, length: theQueryNSString.length - start)
        let dateString = theQueryNSString.substringWithRange(range)
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

