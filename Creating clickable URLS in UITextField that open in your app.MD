##Creating clickable links that do something in your app.

The [**DatesInSwift**](https://github.com/DuncanMC/DatesInSwift.git) app (which you can download from Git at the link by clicking the link) includes a number of "magic dates" to demonstrate using tuples and a Swift switch statement for complex pattern matching.

The magic dates are listed on the screen, but I wanted a way for users to select them without having to enter them manually. 

The app now displays an attributed string listing the magic dates, and those dates are links. If you double-tap or long-press on one of the dates, the app selects that date in the picker and chooses that date.

Here are the steps involved in making that work:

###Teach the app to respond a custom URL scheme
-------------
I defined a new URL scheme, `WTDateLink://`. After setting up the DatesInSwift app correctly and installing it on a device, tapping a link that contains a WTDateLink URL in any app causes the system to offer to open the URL in DatesInSwift.  Here's what you do to make an app support a custom URL scheme:

Add a `CFBundleURLTypes` key to your app's info.plist file. The value for that key is an array of the URL types your app supports. For the DatesInSwift app, we only add one entry, an dictionary with a key CFBundleURLSchemes that contains an array with a single entry, the string `WTDateLink. The whole thing looks like this in XML format:

	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>WTDateLink</string>
			</array>
		</dict>
	</array>

The next step is to implement the `application:openURL:sourceApplication:annotation:` UIApplicationDelegate method. The system calls that method when the user triggers an event to open an URL of a type you've regestered for in your info.plist file.

In DatesForSwift, the URL format it supports is quite simple. A URL looks like this:


	WTDateLink://?date=MM_DD_YYYY

or 

	WTDateLink://?date=today

Which is a special case to pick the current date.

The `application:openURL:sourceApplication:annotation:` method looks like this:

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

###Setting up a UITextView to support tapping on URL links:
-----

The next step is to set up a `UITextView` so that it can contain links and respond to taps on those links.

* Create a UITextView in IB (Interface Builder).
* In the Attributes inspector, do the following:
	* Set the text type to `Attributed`
	* Make the text Selectable but not Editable
	* Under Detection, check "Links."
* Enter your text into the text field. If you want to style your text the easiest way to do it is ot edit the text in TextEdit then copy it and paste it into IB. Unfortuantely, the input box for styled text in IB does not honor links with a user-readable title and a URL that's different than the text that's displayed. The only type of links you can use here are URL strings like `http://www.apple.com/store` or `WTDateLink://?date=12_31_2000". You can't create a link that looks like this: [**The Apple Store**](http://www.apple.com/store). Getting clickable links where the text that's shown is different from the URL requires special tricks.

There are 2 different ways to create a link where the title of the link is different from the URL:

1. Construct an attributed string in code
2. Load an attributed string from a file.

In OSX, the `NSAttributedString` method has an intializer `initWithRTF:documentAttributes:`. You can use it to load an attributed string directly from an RTF file. Unfortunately the iOS version of `NSAttributedString` does not support this initializer.

The good news is that `NSAttributedString` does conform to the NSCoding protocol, which makes it possible to convert an `NSAttributedString` back and forth to NSData.

The solution I've come up with is to write an OSX utility that attributed strings from RTF files using `initWithRTF:documentAttributes:`, then converts them to NSData and saves the data to a file with the suffix ".data". I then load the contents of the file as an attributed string with code like this:

    if
      let datesPath = NSBundle.mainBundle().pathForResource("Dates", ofType: "data"),
      let datesString = NSKeyedUnarchiver.unarchiveObjectWithFile(datesPath) as? NSAttributedString
    {
      datesField.attributedText = datesString
    }

I have created an OSX command line tool that takes a path to an RTF file and an output path as parameters and creates the .data files for use in iOS. I then build that command-line tool into the build process of projects that need to load lots of attributed strings from files. The details of the command line tool are beyond the scope of this document. For this project, I just manually converted my RTF file to a .data file and included the `.data` file in the project.

