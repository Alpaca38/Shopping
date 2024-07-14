//
//  Image.swift
//  Shopping
//
//  Created by 조규연 on 6/13/24.
//

import UIKit

enum Image {
    static let search = UIImage(systemName: "magnifyingglass")
    static let like = UIImage(systemName: "hand.thumbsup")
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
        
        var profileImage: String {
            switch self {
            case .one:
                return "profile_0"
            case .two:
                return "profile_1"
            case .three:
                return "profile_2"
            case .four:
                return "profile_3"
            case .five:
                return "profile_4"
            case .six:
                return "profile_5"
            case .seven:
                return "profile_6"
            case .eight:
                return "profile_7"
            case .nine:
                return "profile_8"
            case .ten:
                return "profile_9"
            case .eleven:
                return "profile_10"
            case .tweleve:
                return "profile_11"
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
