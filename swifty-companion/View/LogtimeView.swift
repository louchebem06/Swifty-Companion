//
//  LogtimeView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 05/12/2022.
//

import SwiftUI

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
	
}

enum MonthType
{
	case Previous
	case Current
	case Next
}

struct MonthStruct
{
	var monthType: MonthType
	var dayInt : Int
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
	
	var body: some View {
		VStack {
			color.overlay(
				Text(monthStruct().day())
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

	init(_ locations: [Location]?) {
		if (locations != nil) {
			let end = stringIsoToDate(locations![0].end_at);
			let begin = stringIsoToDate(locations![locations!.count - 1].begin_at);
			_end = State(initialValue: end);
			_begin = State(initialValue: begin);
			_currentDate = State(initialValue: end);
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
							currentDate: $currentDate,
							count: count,
							startingSpaces: startingSpaces,
							daysInMonth: daysInMonth,
							daysInPrevMonth: daysInPrevMonth,
							color: Color.blue.opacity(0)
						);
					}
				}
			}
		}
		.frame(maxHeight: .infinity)
	}
}

struct LogtimeView_Previews: PreviewProvider {
    static var previews: some View {
		LogtimeView([
			Location(begin_at: "2022-12-04T09:08:35.000Z",
					 end_at: "2022-12-04T18:25:30.000Z",
					 host: "c1r1p1")
		]);
    }
}
