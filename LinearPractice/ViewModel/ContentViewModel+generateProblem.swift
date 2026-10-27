//
//  ContentViewModel+generateProblem.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/27
//  
//
import SwiftUI

// MARK: 問題生成に関連がある機能
extension ContentViewModel {
    func initGenerate() {
        withAnimation {
            self.matrixProblem1 = MatrixProblemModel.generate()
            self.matrixProblem2 = MatrixProblemModel.generate()
        }
        userInput = ""
        inputError = nil
    }

    // 行列生成時の処理を担当。
    func generate() {
        withAnimation {
            if nowProblem == .problem2 {
                self.matrixProblem1 = MatrixProblemModel.generate()
            } else {
                self.matrixProblem2 = MatrixProblemModel.generate()
            }
        }
        userInput = ""
        inputError = nil
    }
}
