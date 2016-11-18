//
//  String+FuzzySearch.swift
//  Tags
//
//  Created by Tomasz Kopycki on 18/11/2016.
//  Copyright © 2016 Amsterdam Standard. All rights reserved.
//

import Foundation


extension String {
    
    func fuzzySearch(stringToSearch: String, caseSensitive: Bool = false) -> Bool {
        
        var searched = self
        var stringToSearch = stringToSearch
        
        if searched.characters.count == 0 || stringToSearch.characters.count == 0 {
            return false
        }
        
        if searched.characters.count < stringToSearch.characters.count {
            return false
        }
        
        if !caseSensitive {
            searched = searched.lowercased()
            stringToSearch = stringToSearch.lowercased()
        }
        
        var searchIndex : Int = 0
        
        for charOut in searched.characters {
            for (indexIn,charIn) in stringToSearch.characters.enumerated() {
                if indexIn == searchIndex {
                    if charOut == charIn {
                        searchIndex += 1
                        if searchIndex == stringToSearch.characters.count {
                            return true
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
            }
        }
        return false
    }
    
}
