//
//  Language.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation

enum LanguageCase {
  case Arabic
  case Azerbaijani
  case Belarusian
  case Bulgarian
  case Bosnian
  case Catalan
  case Czech
  case Danish
  case German
  case Greek
  case English
  case Spanish
  case Estonian
  case Finnish
  case French
  case Hebrew
  case Croatian
  case Hungarian
  case Indonesian
  case Icelandic
  case Italian
  case Japanese
  case Georgian
  case Korean
  case Cornish
  case Latvian
  case Norwegian_Bokmål
  case Dutch
  case Norwegian_Bokmål_alias_for_nb
  case Polish
  case Portuguese
  case Romanian
  case Russian
  case Slovak
  case Slovenian
  case Serbian
  case Swedish
  case Tetum
  case Turkish
  case Ukrainian
  case Igpay_Atinlay
  case simplified_Chinese
  case traditional_Chinese
}

extension LanguageCase {
  static var systemCode: LanguageCase {
    return Locale.preferredLanguages[0].toLanguageCode()
  }
  
  var toString: String {
    switch self {
    case .Arabic: return "ar"
    case .Azerbaijani: return "az"
    case .Belarusian: return "be"
    case .Bulgarian: return "bg"
    case .Bosnian: return "bs"
    case .Catalan: return "ca"
    case .Czech: return "cs"
    case .Danish: return "da"
    case .German: return "de"
    case .Greek: return "el"
    case .English: return "en"
    case .Spanish: return "es"
    case .Estonian: return "et"
    case .Finnish: return "fi"
    case .French: return "fr"
    case .Hebrew: return "he"
    case .Croatian : return "hr"
    case .Hungarian : return "hu"
    case .Indonesian : return "id"
    case .Icelandic : return "is"
    case .Italian : return "it"
    case .Japanese : return "ja"
    case .Georgian : return "ka"
    case .Korean : return "ko"
    case .Cornish : return "kw"
    case .Latvian: return "lv"
    case .Norwegian_Bokmål: return "nb"
    case .Dutch: return "nl"
    case .Norwegian_Bokmål_alias_for_nb: return "no"
    case .Polish: return "pl"
    case .Portuguese: return "pt"
    case .Romanian: return "ro"
    case .Russian: return "ru"
    case .Slovak: return "sk"
    case .Slovenian: return "sl"
    case .Serbian: return "sr"
    case .Swedish: return "sv"
    case .Tetum: return "tet"
    case .Turkish: return "tr"
    case .Ukrainian: return "uk"
    case .Igpay_Atinlay: return "x-pig-latin"
    case .simplified_Chinese: return "zh"
    case .traditional_Chinese: return "zh-tw"
    }
  }
  
}
