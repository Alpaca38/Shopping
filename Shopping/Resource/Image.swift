//
//  Image.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

enum Image {
    static let search = UIImage(systemName: "magnifyingglass")
    static let clock = UIImage(systemName: "clock")
    static let setting = UIImage(systemName: "person")
    static let xmark = UIImage(systemName: "xmark")
    static let next = UIImage(systemName: "chevron.right")
    static let camera = UIImage(systemName: "camera.fill")
    static let launch = UIImage(named: "launch")
    static let empty = UIImage(named: "empty")
    static let likeSelected = UIImage(named: "like_selected")
    static let likeUnSelected = UIImage(named: "like_unselected")
    
    enum Profile {
        case one, two, three, four, five, six, seven, eight, nine, ten, eleven, tweleve
        
        var image: UIImage? {
            switch self {
            case .one:
                return UIImage(named: "profile_0")
            case .two:
                return UIImage(named: "profile_0")
            case .three:
                return UIImage(named: "profile_0")
            case .four:
                return UIImage(named: "profile_0")
            case .five:
                return UIImage(named: "profile_0")
            case .six:
                return UIImage(named: "profile_0")
            case .seven:
                return UIImage(named: "profile_0")
            case .eight:
                return UIImage(named: "profile_0")
            case .nine:
                return UIImage(named: "profile_0")
            case .ten:
                return UIImage(named: "profile_0")
            case .eleven:
                return UIImage(named: "profile_0")
            case .tweleve:
                return UIImage(named: "profile_0")
            }
        }
    }
    
    enum Border: CGFloat {
        case active = 3
        case inActive = 1
    }
    
    enum Alpha: CGFloat {
        case active = 1
        case inActive = 0.5
    }
    
    enum Size: CGFloat {
        case launch
        case bigProfile
        case smallProfile
        
    }
}
