//
//  utils.swift
//  swifty-companion
//
//  Created by Bryan Ledda on 30/11/2022.
//

import Foundation

func parseQuery(_ queryString: String) -> Dictionary<String, String> {
    var query: Dictionary<String, String> = Dictionary();
    let values: Array<Substring> = queryString.split(separator: "&");
    for value in values {
        let valueQuery: Array<Substring> = value.split(separator: "=");
        query[String(valueQuery[0])] = String(valueQuery[1]);
    }
    return (query);
}

func substr(_ string: String, _ start: Int, _ len: Int) -> String {
    var newStr: String = String();
    var i: Int = 0;
    for char in string {
        if (i - start == len) {
            break ;
        }
        if (i < start) {
            i = i + 1;
            continue ;
        }
        newStr.append(char);
        i = i + 1;
    }
    return (newStr);
}

func jsonToDictionary(_ values: String) -> Dictionary<String, Any> {
    var dict: Dictionary<String, Any> = Dictionary();
    let stringNotScope: String = substr(values, 1, values.count - 2);
    let stringSplit: Array<Substring> = stringNotScope.split(separator: ",");
    for string in stringSplit {
        let valueSplit: Array<Substring> = string.split(separator: ":");
        let key: String = substr(String(valueSplit[0]), 1, valueSplit[0].count - 2);
        var value: Any;
        if (valueSplit[1].prefix(1) == "\"") {
            value = substr(String(valueSplit[1]), 1, valueSplit[1].count - 2);
        } else {
            value = Int(valueSplit[1]) ?? -1;
        }
        dict[key] = value;
    }
    return (dict);
}
