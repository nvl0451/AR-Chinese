//
//  Translator.swift
//  rtc_translate
//
//  Created by Андрей Королев on 04.05.2022.
//

import Foundation

func translateString(toTranslate: String, targetLang: String, completionHandler: @escaping(String, Error?) -> Void) {
    let IAM: String = "t1.9euelZqTl5WVnpaYzZrImZSMyceQk-3rnpWaxp7Oy86Tj5uanYrOyMfKkYzl8_dmAG1r-e90eSMt_N3z9yYvamv573R5Iy38.TGHNpOiKdS_pBvTQQ1LDcComcFd_XgOTlZAitajrMr3BtPTbdPWCSMJfyog3d6oJ3dgZWqh-fGbiXnh7zFy3Aw"
    let folderID = "b1gka3m8j6qf9tg3co45"
    let targetLang = targetLang
    let texts = [toTranslate]
    
    let parameters: [String: Any] = [
        "targetLanguageCode": targetLang,
        "texts": texts,
        "folderId": folderID
    ]
    
    let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")!
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(IAM)", forHTTPHeaderField: "Authorization")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
        print(String(describing: error))
        completionHandler("", error)
        return
    }
    
    let task = session.dataTask(with: request) { (data, response, error) in
        
        if let error = error {
            print(String(describing: error))
            completionHandler("", error)
            return
        }
        print("Stage 1")
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
        else {
            print("INVALID RESPONSE")
            completionHandler("", nil)
            return
        }
        print("Stage 2")
        guard let responseData = data else {
            print("nil data")
            completionHandler("", nil)
            return
        }
        print("Stage 3")
        do {
            let translateData = try? JSONDecoder().decode(TranslateData.self, from: responseData)
            print(translateData)
            let translateString = translateData?.translations.first?.text
            print(translateString)
            completionHandler(translateString!, nil)
        } catch let error {
            print(String(describing: error))
            completionHandler("", error)
        }
    }
    
    task.resume()
}
