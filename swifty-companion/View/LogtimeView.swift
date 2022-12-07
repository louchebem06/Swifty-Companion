//
//  LogtimeView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 05/12/2022.
//

import SwiftUI

enum MonthType
{
	case Previous
	case Current
	case Next
}

class CalendarHelper {
	let calendar = Calendar.current
	let dateFormatter = DateFormatter()
	
	func monthYearString(_ date: Date) -> String {
		dateFormatter.dateFormat = "LLL yyyy"
		return dateFormatter.string(from: date)
	}
	
	func plusMonth(_ date: Date) -> Date {
		return calendar.date(byAdding: .month, value: 1, to: date)!
	}
	
	func minusMonth(_ date: Date) -> Date {
		return calendar.date(byAdding: .month, value: -1, to: date)!
	}
	
	func daysInMonth(_ date: Date) -> Int {
		let range = calendar.range(of: .day, in: .month, for: date)!
		return range.count
	}
	
	func dayOfMonth(_ date: Date) -> Int {
		let components = calendar.dateComponents([.day], from: date)
		return components.day!
	}
	
	func firstOfMonth(_ date: Date) -> Date {
		let components = calendar.dateComponents([.year, .month], from: date)
		return calendar.date(from: components)!
	}
	
	func weekDay(_ date: Date) -> Int {
		let components = calendar.dateComponents([.weekday], from: date)
		return components.weekday! - 1
	}
	
	func dayDate(_ date: Date, _ type: MonthType, _ day: Int) -> Date {
		var tmp: DateComponents = calendar.dateComponents(
			[.year, .month, .day],
			from: date
		)
		tmp.day = day;
		if (type == MonthType.Previous) {
			return (minusMonth(dateComposantToDate(tmp)));
		} else if (type == MonthType.Next) {
			return (plusMonth(dateComposantToDate(tmp)));
		}
		return (dateComposantToDate(tmp));
	}
	
	func dateToDate(_ date: Date) -> Date {
		let tmp: DateComponents = calendar.dateComponents(
			[.year, .month, .day],
			from: date
		)
		return (dateComposantToDate(tmp));
	}
}

struct MonthStruct
{
	var monthType: MonthType
	var dayInt: Int
	func day() -> String {
		return String(dayInt)
	}
}

struct CalendarCell: View {
	@Binding var currentDate: Date;
	let count : Int
	let startingSpaces : Int
	let daysInMonth : Int
	let daysInPrevMonth : Int
	let color: Color;
	var percent: Double = 0.0;
	
	init(_ currentDate: Binding<Date>,
		 _ count: Int,
		 _ startingSpaces: Int,
		 _ daysInMonth: Int,
		 _ daysInPrevMonth: Int,
		 _ color: Color,
		 _ logtimes: Dictionary<Date, Int>)
	{
		self._currentDate = currentDate;
		self.count = count;
		self.startingSpaces = startingSpaces;
		self.daysInMonth = daysInMonth;
		self.daysInPrevMonth = daysInPrevMonth;
		self.color = color;
		
		let caseDay: Date = CalendarHelper().dayDate(
			self.currentDate,
			monthStruct().monthType,
			Int(monthStruct().day())!
		);

		let oneDay: Int = 24*60*60;
		if (logtimes[caseDay] != nil) {
			self.percent = Double(logtimes[caseDay]! * 100 / oneDay) / 100;
		}
	}
	
	var body: some View {
		VStack {
			color.opacity(percent).overlay(
				Text("\(monthStruct().day())")
					.foregroundColor(textColor(type: monthStruct().monthType))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			)
		}.frame(height: 50)
	}

	func textColor(type: MonthType) -> Color {
		return type == MonthType.Current ? Color.black : Color.gray
	}
	
	func monthStruct() -> MonthStruct {
		let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
		if(count <= start) {
			let day = daysInPrevMonth + count - start
			return MonthStruct(monthType: MonthType.Previous, dayInt: day)
		} else if (count - start > daysInMonth) {
			let day = count - start - daysInMonth
			return MonthStruct(monthType: MonthType.Next, dayInt: day)
		}
		
		let day = count - start
		return MonthStruct(monthType: MonthType.Current, dayInt: day)
	}
}


struct DateScrollerView: View {
	@Binding var currentDate: Date;
	@Binding var disablePrev: Bool;
	@Binding var disableNext: Bool;
	@Binding var begin: Date;
	@Binding var end: Date;
	
	var body: some View {
		HStack {
			Spacer();
			Button(action: previousMonth) {
				Image(systemName: "arrow.left")
					.imageScale(.large)
					.font(Font.title.weight(.bold));
			}.disabled(disablePrev);
			Text(CalendarHelper().monthYearString(currentDate))
				.font(.title)
				.bold()
				.animation(.none)
				.frame(maxWidth: .infinity);
			Button(action: nextMonth) {
				Image(systemName: "arrow.right")
					.imageScale(.large)
					.font(Font.title.weight(.bold));
			}.disabled(disableNext);
			Spacer();
		}
	}
	
	func previousMonth() {
		currentDate = CalendarHelper().minusMonth(currentDate);
		if (begin > CalendarHelper().minusMonth(currentDate)) {
			disablePrev = true;
		}
		if (end >= CalendarHelper().plusMonth(currentDate)) {
			disableNext = false;
		}
	}
	
	func nextMonth() {
		currentDate = CalendarHelper().plusMonth(currentDate);
		if (begin <= CalendarHelper().minusMonth(currentDate)) {
			disablePrev = false;
		}
		if (CalendarHelper().plusMonth(currentDate) > end) {
			disableNext = true;
		}
	}
}

struct LogtimeView: View {
	@State var begin: Date = Date();
	@State var end: Date = Date();
	@State var disablePrev: Bool = false;
	@State var disableNext: Bool = true;
	@State var currentDate: Date = Date();
	var logtimes: Dictionary<Date, Int> = Dictionary();
	let colorCoa: Color;

	init(_ locations: [Location]?, _ colorCoa: Color) {
		self.colorCoa = colorCoa;
		if (locations != nil) {
			let end = stringIsoToDate(locations![0].end_at);
			let begin = stringIsoToDate(locations![locations!.count - 1].begin_at);
			_end = State(initialValue: end);
			_begin = State(initialValue: begin);
			_currentDate = State(initialValue: end);
			
			for location in locations! {
				let begin_at = stringIsoToDate(location.begin_at);
				let end_at = stringIsoToDate(location.end_at);
				let begin = CalendarHelper().dateToDate(begin_at);
				let end = CalendarHelper().dateToDate(end_at);
				if (logtimes[begin] == nil) {
					logtimes[begin] = 0;
				}
				if (logtimes[end] == nil) {
					logtimes[end] = 0;
				}
				if (begin == end) {
					logtimes[begin]! += Int(end_at.timeIntervalSince1970 - begin_at.timeIntervalSince1970);
				} else {
					logtimes[begin]! += Int(end.timeIntervalSince1970 - begin_at.timeIntervalSince1970);
					logtimes[end]! += Int(end_at.timeIntervalSince1970 - end.timeIntervalSince1970);
				}
			}
		}
		if (CalendarHelper().minusMonth(self.currentDate) < self.begin) {
			_disablePrev = State(initialValue: true);
		}
	}

	var body: some View {
		VStack(spacing: 1) {
			DateScrollerView(
				currentDate: $currentDate,
				disablePrev: $disablePrev,
				disableNext: $disableNext,
				begin: $begin,
				end: $end
			).padding()
			dayOfWeekStack
			calendarGrid
		}
	}

	var dayOfWeekStack: some View {
		HStack(spacing: 1) {
			Text("Sun").dayOfWeek()
			Text("Mon").dayOfWeek()
			Text("Tue").dayOfWeek()
			Text("Wed").dayOfWeek()
			Text("Thu").dayOfWeek()
			Text("Fri").dayOfWeek()
			Text("Sat").dayOfWeek()
		}
	}
	
	var calendarGrid: some View {
		VStack(spacing: 1) {
			let daysInMonth = CalendarHelper().daysInMonth(currentDate)
			let startingSpaces = CalendarHelper().weekDay(currentDate)
			let daysInPrevMonth = CalendarHelper().daysInMonth(currentDate)
			
			ForEach(0..<6){ row in
				HStack(spacing: 1) {
					ForEach(1..<8) { column in
						let count = column + (row * 7)
						CalendarCell(
							$currentDate,
							count,
							startingSpaces,
							daysInMonth,
							daysInPrevMonth,
							colorCoa,
							logtimes
						);
					}
				}
			}
		}
		.frame(maxHeight: .infinity)
	}
}
