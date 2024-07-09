//
//  ProfileViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/9/24.
//

import Foundation

final class ProfileViewModel {
    var outputValidText = Observable("")
    var outputNickname: Observable<String?> = Observable("")
    
    var inputText: Observable<String?> = Observable("")
    
    init() {
        inputText.bind { [weak self] value in
            guard let self, let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            do {
                _ = try validateProfileName(text: text)
                outputValidText.value = TextFieldState.valid
                outputNickname.value = text
            } catch ValidationError.includeSpecial {
                outputValidText.value = TextFieldState.specialCharacter
            } catch ValidationError.includeInt {
                outputValidText.value = TextFieldState.number
            } catch ValidationError.isNotValidCount {
                outputValidText.value = TextFieldState.count
            } catch {
                
            }
        }
    }
    
    private func validateProfileName(text: String) throws -> Bool {
        guard !text.contains(where: { LiteralString.specialCharacter.contains($0) }) else {
            throw ValidationError.includeSpecial
        }
        guard text.rangeOfCharacter(from: .decimalDigits) == nil else {
            throw ValidationError.includeInt
        }
        guard text.count >= 2 && text.count < 10 else {
            throw ValidationError.isNotValidCount
        }
        return true
    }
}
