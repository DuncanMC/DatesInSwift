##DatesInSwift
-----
This app demonstrates a number of iOS techniques in Swift.

It uses a date picker to let the user select a date. When the user taps the OK button, it displays a variety of messages depending on the date selected.

###Extensions to NSDate
------
The program includes a file DateExtensions.swift that provides a number of useful utlities for working with dates.

Normally you can't comare dates using ==, <, <=, >, or >=. The DateExtensions.swift extends NSDate to conform to the Equatable protocol, which allows the == comparison, and the Comparable protocol, which allows <, <=, >, or >= comparisions.

DateExtensions.swift defines a type alias `mdyTuple` which is a tuple containing the month, day, and year value for a date.


There are  utilities that will convert NDate objects back and forth to `mdyTuple` tuples.

The NSDate instance method  mdy() returns an `mdyTuple`.

The global function date(mdy: mdyTyple) takes an `mdyTuple` as input and returns an NSDate.

It turns out that you can't match tuple constants in the cases of a switch statement by default.
In order to do that you have to implement the `~=` (pattern match) operator for the tuple type.

For the mdyTuple type, the pattern match function looks like this:

	/**
	  This function makes it possible to use mdyTuple constants or variables in the cases
	  of switch statements.
	*/
	func ~=(a: mdyTuple, b: mdyTuple) -> Bool {
	  return a.month ~= b.month && a.year ~= b.year && a.day ~= b.day
	}


###Exploring Swift switch statements
------

Swift has a very powerful version of the switch statement. You can match strings, you can match ranges of values, and you can match tuples.

The following a valid in Swift:

	let aString = "foo"
	switch aString
	{
		case "bar":
			println("matched 'bar'")
		case "foo":
				println("matched 'foo'")
		case "foobar":
				println("matched 'foobar'")
		default:
				println("Didn't match anything")
	}

or 

	let a = 10
	switch a
	{
		case 1:									//match a soingle value
			println("value = 1")
		case 3...5:   							//Match a range
			println("value \(a) is between 3 and 5")
		case 7...9: 							//match another range
			println("value \(a) is between 7 and 9")
		case 10:
				println("value == 10")
		case let value where value % 2 == 0:	//wildcard match, boolean after "where" must be true
				println(""value \(a) is even")
		case _:									//match anything
		default:
				println("value \(a) didn't match any of our cases")
	}

But some of the real power of the Swift Switch statment comes in when you use tuples:

	typealias mixedTuple = (String, int, int)
	
	let aTuple: mixedTuple = ()"Bob", 1, 3)
	
	switch aTuple
	{
		case ("Bob", 1, 3):
			println("A perfect match")
			
		case ("Bob", 1, _):
			println("matched all but last value")
			
		case (_, 1, 3):
			println("Values match, name does not.")
		case ("Bob", let middleValue, 3):		//Match on name and last value, 
												//save middle value to a local constant.
			println("Name and last value match, middle value \(middleValue) does not")
			
		case (_, 0...10, 3)
			println("Any name, middle value in range 0...10, last value match.")
		
		default: 
			println("No match.")
	}

The DatesInSwift demo converts the user-selected date to an `mdyTuple`, then uses it to demonstrate various types of switch cases.

First, define some constants:

	let bobsBirthday =    (month: 11, day: 30, year: 1961)
	let janesBirthday =   (month: 10, day: 14, year: 1987)
	let fredsBirthday =   (month: 4, day: 3, year: 1973)
	let patsBirthday =    (month: 7, day: 7, year: 1931)
	let susansBirthday =  (month: 3, day: 8, year: 1933)

Then do some setup:

    //Prefix will be used to build date sentences. 
    //Is the user-selected date in the past, present, or future?
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
    
And finally the switch statement:

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
      message = "\(date) \(prefix) Susan \(possessiveNumber(year - susansBirthday.year)) birthday"
      
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
