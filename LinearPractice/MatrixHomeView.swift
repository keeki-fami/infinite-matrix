//
//  MatrixHomeView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/07/04.
//

import SwiftUI

// View: 行列の表示
struct MatrixGridView: View {
    let matrix: Matrix
    var body: some View {
        VStack(spacing: 4) {
            ForEach(matrix.matrix, id: \.self) { row in
                HStack (spacing: 4) {
                    ForEach(row, id: \.self.id) { num in
                        cellText("\(num.value)")
                    }
                }
                 
            }
        }
    }
}

// View: 行列の要素の表示
func cellText(_ text: String) -> some View {
    Text(text)
        .frame(width: 30, height: 30)
}

// View: 行列の回答の表示
struct MatrixAnswerView: View {
    let matrix: Matrix
    let answerX: Int
    let answerY: Int
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<matrix.matrix.count, id: \.self) { i in
                HStack (spacing: 4) {
                    ForEach(matrix.matrix[i].indices, id: \.self) { j in
                        if i == answerX && j == answerY {
                            cellText("?")
                                .background(.yellow)
                        } else {
                            cellText("\(matrix.matrix[i][j].value)")
                                .id(matrix.matrix[i][j].id)
                        }
                    }
                }
                
            }
        }
    }
}
