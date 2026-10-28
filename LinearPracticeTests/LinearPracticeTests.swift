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

struct MatrixProblemModelTest {
    @Test("行列が2個生成される。")
    func dimOfleftRowAndRightColumn() {
        let matrixProblemModel = MatrixProblemModel.generate()
        switch matrixProblemModel.problemType {
        case .add, .sub, .mul:
            #expect(matrixProblemModel.matrices.count == 2)
        @unknown default:
            print("未実装")
        }
    }
    
    @Test("正しい回答が生成できる")
    func generateCorrectAnswer() {
        for i in 1...3 {
            for j in min(i, 2)...3 {
                let matrix1 = MatrixModel(row: i, column: j)
                let matrix2 = MatrixModel(row: i, column: j)
                
                var matrixProblemModel = MatrixProblemModel(problemType: .add, matricies: [matrix1, matrix2])
                matrixProblemModel.genAnswer()
                
                #expect(matrixProblemModel.ansMatrix != nil)
                
                #expect(matrixProblemModel.ansRow != nil && matrixProblemModel.ansColumn != nil)
                let ansRow = matrixProblemModel.ansRow!
                let ansColumn = matrixProblemModel.ansColumn!
                let ansMatrix = matrixProblemModel.ansMatrix!
                
                #expect(matrixProblemModel.matrices[0].matrix[ansRow][ansColumn] + matrixProblemModel.matrices[1].matrix[ansRow][ansColumn] == matrixProblemModel.ansMatrix!.matrix[ansRow][ansColumn])
                
            }
        }
    }
}
