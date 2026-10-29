//
//  MatrixProblemModel+CheckAnswer.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/29
//  
//

import SwiftUI

// MARK: Check Answer
extension MatrixProblemModel {
    func checkAnswer(answer: Int) -> Bool {
        
        if problemType == .add || problemType == .sub || problemType == .mul {
            precondition(
                ansRow != nil && ansColumn != nil,
                "答えの行, 列が指定されていません。"
            )
            precondition(
                problemType != .determinant && ansMatrix != nil && ansMatrix!.row >= ansRow! && ansMatrix!.column >= ansColumn!,
                "解答の行列が指定されていません。"
            )
        } else {
            precondition(
                problemType == .determinant && ansValue != nil,
                "行列式の回答が指定されていません。"
            )
        }
        switch problemType {
        case .determinant:
            return ansValue! == answer
        case .add, .sub, .mul:
            return ansMatrix!.matrix[ansRow!][ansColumn!] == answer
        }
    }
    
}
