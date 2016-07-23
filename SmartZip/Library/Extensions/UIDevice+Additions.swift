//
//  UIDevice+Additions.swift
//  SmartZip
//
//  Created by Gurkaran Singh on 21/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .Phone
    }
//    enum HHScreenType: String {
//        case iPhone4
//        case iPhone5
//        case iPhone6
//        case iPhone6Plus
//        case Unknown
//    }
//    var screenType: HHScreenType? {
//        guard iPhone else { return nil }
//        switch UIScreen.mainScreen().nativeBounds.height {
//        case 960:
//            return .iPhone4
//        case 1136:
//            return .iPhone5
//        case 1334:
//            return .iPhone6
//        case 2208:
//            return .iPhone6Plus
//        default:
//            return nil
//        }
//    }
}