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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        return true
    }
    
    /*
     This app supports the custom URL scheme `WTDateLink://`. A typical URL is of the form:
     WTDateLink://?date=MM_DD_YYYY or WTDateLink://?date=today.
     
     If we can parse a valid date, we broadcast a notification with the components of the date.
     The app's (only) view controller registers for that notification and uses it to switch the picker to the date.
     
     The app's view controller presents a UITextView that loads the encoded content of an RTF file including links using the WTDateLink:// prefix. Tapping one of those links triggers this method, which sends a notifcation to the view controller.
     */
    
    func application(_ app: UIApplication,
                     open theURL: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var infoDictionary: [AnyHashable: Any]?
        
        //An URL's "query" is everthing after the "?" (should be the "date=..." bit for our URLs) {
        if
            let theQuery = theURL.query?.lowercased(),
            let range = theQuery.range(of: "date=") {
            let dateString = theQuery[range.upperBound...]

            //if the dateString is "today", create an
            //infoDictonary with the components of today's date.
            if dateString == "today" {
                let todayMDY = Date().mdy()
                infoDictionary = [
                    SelectNoticeKeys.month: todayMDY.month,
                    SelectNoticeKeys.day:   todayMDY.day,
                    SelectNoticeKeys.year:  todayMDY.year];
            } else {
                //Otherwise, try to parse a string in the form MM_DD_YYYY
                let components = dateString.components(separatedBy: "_")
                if components.count == 3 {
                    if let month = Int((components[0] as String)),
                        let day = Int((components[1] as String)),
                        let year = Int((components[2] as String)) {
                        if month != 0 && day != 0 && year != 0 {
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
        if infoDictionary != nil {
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: WTNotifications.selectDate),
                object: nil,
                userInfo: infoDictionary
            )
            return true
        } else {
            return false
        }
    }
}
