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
    var problemTypeString: String {
        var matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        if let problem = matrixproblem {
            switch problem.problemType {
            case .add:
                return "行列の足し算"
            case .sub:
                return "行列の引き算"
            case .mul:
                return "行列の掛け算"
            @unknown default:
                return ""
                
            }
        } else {
            return ""
        }
            
    }
    
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
