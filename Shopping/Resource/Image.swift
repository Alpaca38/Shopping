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
    
    enum Profile: Int, CaseIterable {
        case one, two, three, four, five, six, seven, eight, nine, ten, eleven, tweleve
        
        var profileImage: UIImage? {
            switch self {
            case .one:
                return UIImage(named: "profile_0")
            case .two:
                return UIImage(named: "profile_1")
            case .three:
                return UIImage(named: "profile_2")
            case .four:
                return UIImage(named: "profile_3")
            case .five:
                return UIImage(named: "profile_4")
            case .six:
                return UIImage(named: "profile_5")
            case .seven:
                return UIImage(named: "profile_6")
            case .eight:
                return UIImage(named: "profile_7")
            case .nine:
                return UIImage(named: "profile_8")
            case .ten:
                return UIImage(named: "profile_9")
            case .eleven:
                return UIImage(named: "profile_10")
            case .tweleve:
                return UIImage(named: "profile_11")
            }
        }
    }
    
    enum Border {
        static let active: CGFloat = 3
        static let inActive: CGFloat = 1
    }
    
    enum Alpha {
        static let active: CGFloat = 1
        static let inActive: CGFloat = 0.5
    }
    
    enum Size {
        static let bigProfile: CGFloat = 100
        static let smallProfile: CGFloat = 80
        static let camera: CGFloat = 25
        static let clock: CGFloat = 10
        static let xmark: CGFloat = 10
    }
}
