//
//  RuntimeError.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 06/12/2022.
//

import Foundation

struct RuntimeError: Error
{
	let message: String

	init(_ message: String)
	{
		self.message = message
	}

	public var errorDescription: String?
	{
		return message
	}
}
