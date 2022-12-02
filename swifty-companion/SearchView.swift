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
    
    var body: some View {
        if (search) {
            ZStack {
                HStack {
                    TextField(
                        "Search login 42",
                        text: $tmpInput
                    ).padding(15)
                        .buttonBorderShape(.roundedRectangle(radius: 10));
                    
                    Button("Search") {
                        Task () {
                            isRequestInProgress = true;
                            tmpInput = tmpInput.lowercased();
                            tmpInput = tmpInput.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil);
                            // TODO check if content only a-z 0-9 and -
                            // OR Api getValue() thrown generation URL
                            let value: String = await Api.getValue("/v2/users/\(tmpInput)");
                            do {
                                let data: Data = value.data(using: .utf8)!;
                                user = try JSONDecoder().decode(User.self, from: data);
                                if (user.id != nil) {
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
                            isRequestInProgress = false;
                        }
                    }.padding(15)
                        .buttonBorderShape(.roundedRectangle)
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
