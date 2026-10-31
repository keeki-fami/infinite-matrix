//
//  MatrixProblemModel.swift
//  LinearPractice
//

import Foundation

enum ProblemType: CaseIterable {
    case add
    case sub
    case mul
    case determinant
}

extension MatrixProblemModel: Identifiable {}


struct MatrixProblemModel {
    // Identifiable
    var id: String
    
    var problemType: ProblemType
    var matrices: [MatrixModel]
    
    var ansMatrix: MatrixModel?
    var ansValue: MatrixValue?
    var ansRow: Int?
    var ansColumn: Int?
    
    // CheckAnswer
    var isSuccess = false
    
    init(problemType: ProblemType, matricies: [MatrixModel], ansMatrix: MatrixModel? = nil, ansRow: Int? = nil, ansColumn: Int? = nil) {
        self.id = UUID().uuidString
        self.matrices = matricies
        self.problemType = problemType
        self.ansMatrix = ansMatrix
        self.ansRow = ansRow
        self.ansColumn = ansColumn
    }

    private func isRectangular(_ matrix: [[Int]]) -> Bool {
        guard let firstRow = matrix.first, !firstRow.isEmpty else {
            return false
        }
        return matrix.allSatisfy { $0.count == firstRow.count }
    }
}
