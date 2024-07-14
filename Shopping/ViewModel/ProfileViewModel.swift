//
//  ProfileViewModel.swift
//  Shopping
//
//  Created by 조규연 on 7/9/24.
//

import Foundation

final class ProfileViewModel {
    var outputValidText = Observable("")
    var outputNickname = Observable("")
    var outputValid = Observable(false)
    
    var inputText: Observable<String?> = Observable("")
    
    init() {
        inputText.bind { [weak self] value in
            guard let self, let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            do {
                _ = try validateProfileName(text: text)
                outputValidText.value = TextFieldState.valid
                outputNickname.value = text
                outputValid.value = true
            } catch ValidationError.includeSpecial {
                outputValidText.value = TextFieldState.specialCharacter
                outputValid.value = false
            } catch ValidationError.includeInt {
                outputValidText.value = TextFieldState.number
                outputValid.value = false
            } catch ValidationError.isNotValidCount {
                outputValidText.value = TextFieldState.count
                outputValid.value = false
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
