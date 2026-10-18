//
//  LinearPracticeTests.swift
//  LinearPracticeTests
//  
//  Created by keeki-fami on 2026/10/18
//  
//
// Swift Testing Documentation
// https://developer.apple.com/documentation/testing

import Testing
@testable import LinearPractice

struct MatrixModelTest {
    @Test("行数、列数が正しく指定されているか")
    func generateMatrixModelTest() {
        for i in 1...3 {
            for j in 1...3 {
                let matrix = MatrixModel(row: i, column: j)
                #expect(matrix.row == i && matrix.column == j)
            }
        }
    }

}
