//
//  utils.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation
import SwiftUI

func parseQuery(_ queryString: String) -> Dictionary<String, String> {
    var query: Dictionary<String, String> = Dictionary();
    let values: Array<Substring> = queryString.split(separator: "&");
    for value in values {
        let valueQuery: Array<Substring> = value.split(separator: "=");
        query[String(valueQuery[0])] = String(valueQuery[1]);
    }
    return (query);
}

func hexStringToColor (_ hex:String) -> Color {
	var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

	if (cString.hasPrefix("#")) {
		cString.remove(at: cString.startIndex)
	}

	if ((cString.count) != 6) {
		return Color.gray
	}

	var rgbValue:UInt64 = 0
	Scanner(string: cString).scanHexInt64(&rgbValue)

	return Color(UIColor(
		red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
		green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
		blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
		alpha: CGFloat(1.0))
	)
}

func stringIsoToDate(_ dateString: String?) -> Date {
	if (dateString == nil) {
		return (Date());
	}
	let formatter = ISO8601DateFormatter()
	formatter.formatOptions.insert(.withFractionalSeconds)
	let date: Date = formatter.date(from: dateString!)!;
	return (date);
}

func dateComposantToDate(_ date: DateComponents) -> Date {
	return (Calendar.current.date(from: date)!);
}

extension String {
	func firstLetterInUpper() -> String {
		return (
			"\(self.prefix(1).uppercased())\(self.lowercased().dropFirst())"
		);
	}
}

extension Text {
	func dayOfWeek() -> some View {
		self.frame(maxWidth: .infinity)
			.padding(.top, 1)
			.lineLimit(1)
	}
}
