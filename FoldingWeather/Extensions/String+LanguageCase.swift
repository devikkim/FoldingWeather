//
//  String+LanguageCase.swift
//  FoldingWeather
//
//  Created by InKwon on 08/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

extension String {
  func toLanguageCode() -> LanguageCase {
    switch self {
    case "ar": return .Arabic
    case "az": return .Azerbaijani
    case "be": return .Belarusian
    case "bg": return .Bulgarian
    case "bs": return .Bosnian
    case "ca": return .Catalan
    case "cs": return .Czech
    case "da": return .Danish
    case "de": return .German
    case "el": return .Greek
    
    case "en",
         "en-GB",
         "en-CA",
         "en-IN": return .English
      
    case "es",
         "es-MX": return .Spanish
      
    case "et": return .Estonian
    case "fi": return .Finnish
    
    case "fr",
         "fr-CA": return .French
      
    case "he": return .Hebrew
    case "hr": return .Croatian
    case "hu": return .Hungarian
    case "id": return .Indonesian
    case "is": return .Icelandic
    case "it": return .Italian
    case "ja": return .Japanese
    case "ka": return .Georgian
    
    case "ko",
         "ko-KR": return .Korean
      
    case "kw": return .Cornish
    case "lv": return .Latvian
    case "nb": return .Norwegian_Bokmål
    case "nl": return .Dutch
    case "no": return .Norwegian_Bokmål_alias_for_nb
    case "pl": return .Polish
    
    case "pt",
         "pt-BR": return .Portuguese
    
    case "ro": return .Romanian
    case "ru": return .Russian
    case "sk": return .Slovak
    case "sl": return .Slovenian
    case "sr": return .Serbian
    case "sv": return .Swedish
    case "tet": return .Tetum
    case "tr": return .Turkish
    case "uk": return .Ukrainian
      
    case "zh",
         "zh-Hans": return .simplified_Chinese
    
    case "zh-tw",
         "zh-Hant": return .traditional_Chinese
      
    default:
      return .English
    }
  }
}
