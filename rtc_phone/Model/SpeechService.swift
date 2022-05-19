//
//  SpeechService.swift
//  rtc_tts
//
//  Created by Андрей Королев on 03.05.2022.
//

import Foundation
import AVKit
import NaturalLanguage

class SpeechService: NSObject {
    
    //shared instance
    static let shared = SpeechService()
    
    let speechSynth = AVSpeechSynthesizer()
    
    var pitch: Float = 1
    var minRate: Float = AVSpeechUtteranceMinimumSpeechRate
    var maxRate: Float = AVSpeechUtteranceMaximumSpeechRate
    
    //MARK: - speech methods
    
    public func startSpeech(_ text: String, _ pitchValue: Float, _ rateValue: Float) {
        stopSpeech()
        
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        if let lang = recognizer.dominantLanguage {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: lang.rawValue)
            
            utterance.pitchMultiplier = 0.5 + (pitchValue * 1.5)
            utterance.rate = minRate + (maxRate - minRate) * rateValue
            
            speechSynth.speak(utterance)
        }
    }
    
    func stopSpeech() {
        speechSynth.stopSpeaking(at: .immediate)
    }
}
