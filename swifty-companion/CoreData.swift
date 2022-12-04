//
//  CoreData.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 04/12/2022.
//

import Foundation
import CoreData

class CoreData {
	private let container: NSPersistentContainer = NSPersistentContainer(name: "swifty-companion");

	init () {
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error: \(error.localizedDescription)")
			}
		}
	}
	
	private func getContext() -> NSManagedObjectContext {
		return (container.viewContext);
	}
	
	func insert(_ token: Token) -> Void {
		let context = getContext();
		let tokenEntity = TokenEntity(context: context);
		tokenEntity.scope = token.scope;
		tokenEntity.access_token = token.access_token;
		tokenEntity.refresh_token = token.refresh_token;
		tokenEntity.token_type = token.token_type;
		tokenEntity.expires_in = Int64(token.expires_in!);
		tokenEntity.created_at = Int64(token.created_at!);
		if context.hasChanges {
			do {
				try context.save();
			} catch {
				print("Error save token entity");
			}
		}
	}
	
	func readAll() -> [Token] {
		let context = getContext();
		var tokenTab: [Token] = [];
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
		request.returnsObjectsAsFaults = false
		do {
			let result = try context.fetch(request)
			for data in result as! [NSManagedObject] {
				var token: Token = Token();
				token.access_token = (data.value(forKey: "access_token") as! String);
				token.scope = (data.value(forKey: "scope") as! String);
				token.refresh_token = (data.value(forKey: "refresh_token") as! String);
				token.token_type = (data.value(forKey: "token_type") as! String);
				token.expires_in = (data.value(forKey: "expires_in") as! Int);
				token.created_at = (data.value(forKey: "created_at") as! Int);
				tokenTab.append(token);
			}
		} catch {
			print("Failed")
		}
		return (tokenTab);
	}
}
