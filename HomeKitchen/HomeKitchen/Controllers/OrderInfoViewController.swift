//
//  OrderInfoViewController.swift
//  HomeKitchen
//
//  Created by Tan Vo on 9/15/17.
//  Copyright © 2017 Tan Vo. All rights reserved.
//

import UIKit
import CVCalendar

struct Color {
  static let selectedText = UIColor.white
  static let text = UIColor.black
  static let textDisabled = UIColor.gray
  static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
  static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
  static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
  static let sundaySelectionBackground = sundayText
}

class OrderInfoViewController: UIViewController {
  
  // MARK: IBOutlet
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var phoneTextField: UITextField!
  
  @IBOutlet weak var dateTextField: UITextField!
  
  @IBOutlet weak var timeTextField: UITextField!
  
  // Calendar
  
  @IBOutlet weak var menuView: CVCalendarMenuView!
  
  @IBOutlet weak var calendarView: CVCalendarView!
  
  @IBOutlet weak var monthLabel: UILabel!
  var selectedDay:DayView!
  var currentCalendar: Calendar?
  var animationFinished = true
  var shouldShowDaysOut = true
  
  let datePicker = UIDatePicker()
  
  // Check for function prevent scroll to previous month
  var isCurrentMonth: Bool = true
  var savingCurrentMonth: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set current date for Calendar
    if let currentCalendar = currentCalendar {
      monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
      savingCurrentMonth = CVDate(date: Date(), calendar: currentCalendar).globalDescription
    }
    // Create datePicker for timeTextField
    createDatePicker()
    // Disable the day before current date
    disablePreviousDays()
    // Delegate of scrollview of calendarView
    calendarView.contentController.scrollView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Show date out of current month
    calendarView.changeDaysOutShowingState(shouldShow: true)
    shouldShowDaysOut = true
  }
  
  override func awakeFromNib() {
    let timeZoneBias = 480 // (UTC+08:00)
    currentCalendar = Calendar.init(identifier: .gregorian)
    if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
      currentCalendar?.timeZone = timeZone
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    menuView.commitMenuViewUpdate()
    calendarView.commitCalendarViewUpdate()
  }
}

extension OrderInfoViewController {
  // Disable (change to grey and disable) the day before current date
  func disablePreviousDays() {
    let calendar = Calendar.current
    for weekV in calendarView.contentController.presentedMonthView.weekViews {
      for dayView in weekV.dayViews {
        
        if calendar.compare(dayView.date.convertedDate()!, to: Date(), toGranularity: .day) == .orderedAscending {
          dayView.isUserInteractionEnabled = false
          dayView.dayLabel.textColor = calendarView.appearance.dayLabelWeekdayOutTextColor
        }
      }
    }
  }
  
  // Check the month on calendar is current month or not
  func checkCurrentMonth(content: String) {
    if savingCurrentMonth.caseInsensitiveCompare(content) == .orderedSame {
      isCurrentMonth = true
    } else {
      isCurrentMonth = false
    }
  }
}

// MARK: UIScrollDelegate
extension OrderInfoViewController: UIScrollViewDelegate {
  // Catch scroll action
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // If calendar's month is current month, disable scroll action
    if isCurrentMonth {
      //   The minPos in X in the scrollView it is fixed to the width of the calendar,
      //  because the Calendar holds 3 views of the same width that represent the previous,
      //  current and next month, so setting this to the width of the calendar will omit the
      // previousMonth.
      let minPos = calendarView.frame.width
      if scrollView.contentOffset.x < minPos {
        scrollView.contentOffset = CGPoint(x: minPos, y: 0)
      }
    }
    (calendarView.contentController as! MonthContentViewController).scrollViewDidScroll(scrollView)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    (calendarView.contentController as! MonthContentViewController).scrollViewWillBeginDragging(scrollView)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    (calendarView.contentController as! MonthContentViewController).scrollViewDidEndDecelerating(scrollView)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    (calendarView.contentController as! MonthContentViewController).scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
  }
}

extension OrderInfoViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
  /// Required method to implement!
  func presentationMode() -> CalendarMode {
    return .monthView
  }
  
  /// Required method to implement!
  func firstWeekday() -> Weekday {
    return .sunday
  }
  
  // MARK: Optional methods
  
  func calendar() -> Calendar? {
    return currentCalendar
  }
  
  func shouldShowWeekdaysOut() -> Bool {
    return shouldShowDaysOut
  }
  
  func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
    selectedDay = dayView
    print("====date: \(dayView.date.day)")
    print("====weekdayIndex: \(dayView.weekdayIndex!)")
    print("====month: \(dayView.date.month)")
    print("====year: \(dayView.date.year)")
  }
  
  func presentedDateUpdated(_ date: CVDate) {
    if monthLabel.text != date.globalDescription && self.animationFinished {
      let updatedMonthLabel = UILabel()
      updatedMonthLabel.textColor = monthLabel.textColor
      updatedMonthLabel.font = monthLabel.font
      updatedMonthLabel.textAlignment = .center
      updatedMonthLabel.text = date.globalDescription
      updatedMonthLabel.sizeToFit()
      updatedMonthLabel.alpha = 0
      updatedMonthLabel.center = self.monthLabel.center
      
      let offset = CGFloat(48)
      updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
      updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
      
      // Check isCurrentMonth
      checkCurrentMonth(content: updatedMonthLabel.text!)
      // Disable previous days if month is current month
      // repeat function when update month
      if isCurrentMonth {
        disablePreviousDays()
      }
      
      UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        self.animationFinished = false
        self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        self.monthLabel.alpha = 0
        
        updatedMonthLabel.alpha = 1
        updatedMonthLabel.transform = CGAffineTransform.identity
        
      }) { _ in
        
        self.animationFinished = true
        self.monthLabel.frame = updatedMonthLabel.frame
        self.monthLabel.text = updatedMonthLabel.text
        self.monthLabel.transform = CGAffineTransform.identity
        self.monthLabel.alpha = 1
        updatedMonthLabel.removeFromSuperview()
      }
      
      // self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
    }
  }
  
  func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
    let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
    circleView.fillColor = .colorFromCode(0xCCCCCC)
    return circleView
  }
  
  func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
    if (dayView.isCurrentDay) {
      return true
    }
    return false
  }
  
  func disableScrollingBeforeDate() -> Date {
    return Date()
  }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension OrderInfoViewController: CVCalendarViewAppearanceDelegate {
  func dayLabelWeekdayDisabledColor() -> UIColor {
    return UIColor.lightGray
  }
  
  func dayLabelPresentWeekdayInitallyBold() -> Bool {
    return false
  }
  
  func spaceBetweenDayViews() -> CGFloat {
    return 0
  }
  
  func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
  
  func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
    switch (weekDay, status, present) {
    case (_, .selected, _), (_, .highlighted, _): return Color.selectedText
    case (.sunday, .in, _): return Color.sundayText
    case (.sunday, _, _): return Color.sundayTextDisabled
    case (_, .in, _): return Color.text
    default: return Color.textDisabled
    }
  }
  
  func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
    switch (weekDay, status, present) {
    case (.sunday, .selected, _), (.sunday, .highlighted, _): return Color.sundaySelectionBackground
    case (_, .selected, _), (_, .highlighted, _): return Color.selectionBackground
    default: return nil
    }
  }
}

extension OrderInfoViewController {
  func toggleMonthViewWithMonthOffset(offset: Int) {
    guard let currentCalendar = currentCalendar else {
      return
    }
    
    var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar) // from today
    
    components.month! += offset
    
    let resultDate = currentCalendar.date(from: components)!
    
    self.calendarView.toggleViewWithDate(resultDate)
  }
  
  
  func didShowNextMonthView(_ date: Date) {
    guard let currentCalendar = currentCalendar else {
      return
    }
    
    let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
    
    print("Showing Month: \(components.month!)")
    // Disable the day before current date
  }
  
  
  func didShowPreviousMonthView(_ date: Date) {
    guard let currentCalendar = currentCalendar else {
      return
    }
    
    let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
    
    print("Showing Month: \(components.month!)")
    // Disable the day before current date
  }
  
}

extension OrderInfoViewController {
  func createDatePicker() {
    // Format the display of datepicker
    datePicker.datePickerMode = .time
    
    timeTextField.inputView = datePicker
    
    // Create a toolbar
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    // Add a done button on this toolbar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
    toolbar.setItems([doneButton], animated: true)
    timeTextField.inputAccessoryView = toolbar
    
  }
  
  func doneClicked() {
    // Format the date displays on textfield
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    
    timeTextField.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
}
