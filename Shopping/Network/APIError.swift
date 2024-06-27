//
//  NetworkError.swift
//  Shopping
//
//  Created by 조규연 on 6/27/24.
//

import Foundation

enum APIError: String, Error {
    case invalidRequestVariables = "요청 변수를 확인해주세요."
    case invalidURL = "API 요청 URL이 잘못 되었는지 확인해주세요."
    case failedAuthentication = "인증에 실패하였습니다."
    case invalidReauest = "잘못된 요청입니다. 요청 변수 혹은 프로토콜이 HTTPS인지 확인해주세요."
    case invalidMethod = "잘못된 메서드 요청입니다."
    case requestLimit = "API 호출 허용량을 초과했습니다."
    case serverError = "서버에 오류가 발생해 응답할 수 업습니다.."
    case networkDelay = "요청 대기시간을 초과했습니다. 네트워크 상태를 확인해주세요."
}
