//
//  MatrixHomeView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/07/04.
//

import SwiftUI

// View: 行列の表示
struct MatrixGridView: View {
    let matrix: MatrixModel
    @State var hSize: CGFloat = 0
    var body: some View {
        HStack {
            Image("left")
                .resizable()
                .frame(width: 10, height: hSize)
            VStack(spacing: 4) {
                ForEach(matrix.matrix, id: \.self) { row in
                    HStack (spacing: 4) {
                        ForEach(row, id: \.self) { num in
                            cellText("\(num.value)")
                        }
                    }
                    
                }
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size.height) {
                        withAnimation {
                            hSize = geometry.size.height
                        }
                        print(geometry.size)
                    }
                    .onAppear {
                        hSize = geometry.size.height
                    }
            })
            Image("right")
                .resizable()
                .frame(width: 10, height: hSize)
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
    let matrix: MatrixModel
    let answerX: Int
    let answerY: Int
    @Binding var isSuccess: Bool
    @State private var hSize: CGFloat = 0
    @State private var point: CGPoint = .init()
    var body: some View {
        HStack {
            Image("left")
                .resizable()
                .frame(width: 10, height: hSize)
                .zIndex(999)
            
            VStack(spacing: 4) {
                ForEach(0..<matrix.row, id: \.self) { i in
                    HStack (spacing: 4) {
                        ForEach(matrix.matrix[i].indices, id: \.self) { j in
                            if i == answerX && j == answerY {
                                Group {
                                    if !isSuccess {
                                        cellText("?")
                                            .background(
                                                Color.yellow
                                            )
                                    } else {
                                        cellText("\(matrix.matrix[i][j].value)")
                                    }
                                }
                                .particleEffect(trigger: isSuccess)
                            } else {
                                cellText("\(matrix.matrix[i][j].value)")
                            }
                        }
                    }
                    
                }
            }
            .background(GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size.height) {
                        withAnimation {
                            hSize = geometry.size.height
                        }
                        print(geometry.size)
                    }
                    .onAppear {
                        hSize = geometry.size.height
                    }
            })
            
            Image("right")
                .resizable()
                .frame(width: 10, height: hSize)
                .zIndex(999)
        }
    }
}
