//
//  Tagger.swift
//  rtc_phone
//
//  Created by Андрей Королев on 12.05.2022.
//

import Foundation
import NaturalLanguage

class Tagger {
    static let shared = Tagger()
    
    func decomposeString(input: String, completion: @escaping([String], [String]) -> Void) {
        var engStrings: [String] = []
        var myTags: [String] = []
        
        let text = input
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        
        print(tagger.dominantLanguage)
        tagger.setLanguage(.english, range: text.startIndex..<text.endIndex)
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                engStrings.append(String(text[tokenRange]))
                myTags.append(tag.rawValue)
                //print("\(text![tokenRange]): \(tag.rawValue)")
            }
            
            //print("\(text![tokenRange]): \(tag?.rawValue)")
            
            //let (hypo, _) = tagger.tagHypotheses(at: tokenRange.lowerBound, unit: .word, scheme: .nameType, maximumCount: 1)
            //print(hypo)
            
            return true
        }
        
        completion(engStrings, myTags)
    }
}
