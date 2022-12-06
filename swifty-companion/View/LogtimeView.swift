//
//  LogtimeView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 05/12/2022.
//

import SwiftUI

// https://www.youtube.com/watch?v=jBvkFKhnYLI

class DateHolder: ObservableObject {
	@Published var date: Date;
	
	init(_ date: Date) {
		self.date = date;
	}
}

class CalendarHelper {
	let calendar = Calendar.current;
	let dateFormatter = DateFormatter();
	
	func monthYearString(_ date: Date) -> String {
		dateFormatter.dateFormat = "LLL yyyy";
		return (dateFormatter.string(from: date));
	}
	
	func plusMonth(_ date: Date) -> Date {
		return (calendar.date(byAdding: .month, value: 1, to: date)!);
	}
	
	func minusMonth(_ date: Date) -> Date {
		return (calendar.date(byAdding: .month, value: -1, to: date)!);
	}
}

struct DateScrollerView: View {
	@EnvironmentObject var dateHolder: DateHolder;
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
			Text(CalendarHelper().monthYearString(dateHolder.date))
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
		dateHolder.date = CalendarHelper().minusMonth(dateHolder.date);
	}
	
	func nextMonth() {
		dateHolder.date = CalendarHelper().plusMonth(dateHolder.date);
	}
}

struct LogtimeView: View {
	@State var begin: Date = Date();
	@State var end: Date = Date();
	@State var disablePrev: Bool = false;
	@State var disableNext: Bool = true;
	@ObservedObject var dateHolder: DateHolder;

	init(_ locations: [Location]?) {
		if (locations != nil) {
			let end = stringIsoToDate(locations![0].end_at);
			let begin = stringIsoToDate(locations![locations!.count - 1].begin_at);
			_end = State(initialValue: end);
			_begin = State(initialValue: begin);
		}
		dateHolder = DateHolder(end);
		if (CalendarHelper().minusMonth(dateHolder.date) < self.begin) {
			disablePrev = true;
		}
	}

	var body: some View {
		DateScrollerView(disablePrev: $disablePrev, disableNext: $disableNext, begin: $begin, end: $end)
			.environmentObject(dateHolder);
	}
}

struct LogtimeView_Previews: PreviewProvider {
    static var previews: some View {
		LogtimeView([
			Location(begin_at: "2022-12-04T09:08:35.000Z",
					 end_at: "2022-12-04T18:25:30.000Z",
					 host: "c1r1p1"),
			Location(begin_at: "2022-12-01T09:08:35.000Z",
					 end_at: "2022-12-31T18:25:30.000Z",
					 host: "c1r1p1")
		]);
    }
}
