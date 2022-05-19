//
//  TranslationVC.swift
//  rtc_phone
//
//  Created by Андрей Королев on 06.05.2022.
//

import UIKit
import NaturalLanguage

class TranslationVC: UIViewController {
    
    var myString: String = ""
    
    var passTranslation: String = ""
    
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var pinyinText: UITextView!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var translationText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFields(chineseString: myString)
    }
    
    func initFields() {
        mainText.text = "chin chen"
        pinyinText.text = "chin chen"
        translationText.text = ""
        print(mainText)
    }
    
    func setupFields(chineseString: String) {
        print(chineseString)
        print(mainText.text!)
        mainText.text = chineseString
        
        translationText.text = passTranslation
        
        let pinyin = chineseString.toPinyin()
        pinyinText.text = pinyin
        
        if (translationText.text != "" && translationText.text != pinyinText.text) {
            return
        }
        
        var translated = "Error accessing Yandex Translate services!"
        translateString(toTranslate: mainText.text, targetLang: "ru") { (string, error) in
            if let error = error {
                print(String(describing: error))
                return
            }
            print(string)
            translated = string
            DispatchQueue.main.async {
                self.translationText.text = translated
            }
        }
        print("translated \(translated)")
        translationText.text = translated
    }
    
    
    @IBAction func voiceDidTapped(_ sender: UIButton) {
        if sender != voiceButton {
            return
        }
        SpeechService.shared.startSpeech(mainText.text, rateSlider.value * 0.5, rateSlider.value * 0.5)
    }
    
    
    @IBAction func infoDidTapped(_ sender: Any) {
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "infoSegue" {
            print("segue starts")
            let target = segue.destination as! InfoTVC
            translateString(toTranslate: mainText.text, targetLang: "en") { (string, error) in
                if let error = error {
                    print(String(describing: error))
                    return
                }
                print(string)
                let translated = string
                DispatchQueue.main.async {
                    print("putting \(translated) in")
                    target.initString = translated
                    target.decomposeInitString()
                }
            }
        }
    }

}
