//
//  LogtimeView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 05/12/2022.
//

import SwiftUI

struct Logtime {
	let begin: Date
	let end: Date
}

struct DateAndLogtime {
	let day: Int
	let month: Int
	let year: Int
	let timestamp: Int;
}

struct LogtimeView: View {
	let begin: Date;
	let end: Date;
	var logtimes: [DateAndLogtime] = [];

	init(_ locations: [Location]?) {
		var logtimes: [Logtime] = [];
		if (locations != nil) {
			self.end = stringIsoToDate(locations![0].end_at);
			self.begin = stringIsoToDate(locations![locations!.count - 1].begin_at);
			for location in locations! {
				// print(location.host);
				logtimes.append(
					Logtime(
						begin: stringIsoToDate(location.begin_at),
						end: stringIsoToDate(location.end_at)
					)
				);
			}
			for logtime in logtimes {
				let begin = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: logtime.begin);
				let end = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: logtime.end);
				if (begin.day == end.day) {
					self.logtimes.append(
						DateAndLogtime(
							day: begin.day!,
							month: begin.month!,
							year: begin.year!,
							timestamp: Int(abs(logtime.end.timeIntervalSince1970 - logtime.begin.timeIntervalSince1970))
						)
					);
				} else {
					var dateComponents = DateComponents();
					dateComponents.year = end.year;
					dateComponents.month = end.month;
					dateComponents.day = end.day;
					dateComponents.timeZone = TimeZone(abbreviation: "UTC");
					dateComponents.hour = 0;
					dateComponents.minute = 0;
					dateComponents.second = 0;
					let tmp: Date = dateComposantToDate(dateComponents);
					self.logtimes.append(
						DateAndLogtime(
							day: begin.day!,
							month: begin.month!,
							year: begin.year!,
							timestamp: Int(abs(tmp.timeIntervalSince1970 - logtime.begin.timeIntervalSince1970))
						)
					);
					self.logtimes.append(
						DateAndLogtime(
							day: end.day!,
							month: end.month!,
							year: end.year!,
							timestamp: Int(abs(logtime.end.timeIntervalSince1970 - tmp.timeIntervalSince1970))
						)
					);
				}
			}
		} else {
			begin = Date();
			end = Date();
		}
	}

	var body: some View {
		Text("Hello World");
	}
}

struct LogtimeView_Previews: PreviewProvider {
    static var previews: some View {
		LogtimeView([
			Location(begin_at: "2022-12-04T09:08:35.000Z",
					 end_at: "2022-12-04T18:25:30.000Z",
					 host: "c1r1p1"),
		]);
    }
}
