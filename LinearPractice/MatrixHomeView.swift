//
//  MatrixHomeView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/07/04.
//

import SwiftUI

// View:
//struct MatrixHomeView: View {
//    var generator: MatrixGenerator = MatrixGenerator()
//    var body: some View {
//        VStack {
//            HStack {
//                MatrixGridView(matrix: generator.matrixset.matrix1)
////                operatorText
//                MatrixGridView(matrix: generator.matrixset.matrix2)
//            }
//            HStack {
//                cellText("=")
//                MatrixAnswerView(
//                    matrix: generator.matrixset.matrixAnswer,
//                    answerX: generator.matrixset.answerPointX,
//                    answerY: generator.matrixset.answerPointY
//                )
//            }
//        }
//        .onAppear() {
//            generator.generate()
//        }
//        
//    }
//    
//}

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

func cellText(_ text: String) -> some View {
    Text(text)
        .frame(width: 30, height: 30)
}

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

//#Preview {
//    MatrixHomeView()
//}
