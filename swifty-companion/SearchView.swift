//
//  SearchView.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var tmpInput: String = "";
    @State private var search: Bool = true;
    @State private var user: User = User();
    @State private var showAlert = false
    @State private var titleError: String = "";
    @State private var messageError: String = "";
    @State private var isRequestInProgress: Bool = false;
	@State private var disabledButton: Bool = false;
    
    var body: some View {
        if (search) {
            ZStack {
                HStack {
                    TextField(
                        "Search login 42",
                        text: $tmpInput
                    ).padding(15);
                    
                    Button("Search") {
						disabledButton = true;
						Task () {
							isRequestInProgress = true;
							tmpInput = tmpInput.lowercased();
							tmpInput = tmpInput.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil);
							var value: String = await Api.getValue("/v2/users/\(tmpInput)");
							if (value == "" || tmpInput.isEmpty) {
								titleError = "Invalid login";
								messageError = "'\(tmpInput)' is invalid";
								showAlert = true;
							} else {
								do {
									var data: Data = value.data(using: .utf8)!;
									user = try JSONDecoder().decode(User.self, from: data);
									if (user.id != nil) {
										let idUserString: String = String(user.id!);
										value = await Api.getValue("/v2/users/\(idUserString)/coalitions");
										data = value.data(using: .utf8)!;
										user.coalitions = try JSONDecoder().decode([Coalition].self, from: data);
										search = false;
									} else {
										titleError = "User not found";
										messageError = "\(tmpInput) is not valid user 42";
										showAlert = true;
									}
								} catch {
									titleError = "Request error";
									messageError = "Error: \(error)";
									showAlert = true;
								}
							}
							isRequestInProgress = false;
							disabledButton = false;
						}
					}.disabled(disabledButton)
						.padding(15)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(titleError),
                                message: Text(messageError)
                            )
                        };
                };
                if isRequestInProgress {
                    ProgressView();
                }
            }
        } else {
            IntraView(user);
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
