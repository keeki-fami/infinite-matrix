//
//  MatrixModel.swift
//  LinearPractice
//

import Foundation

struct MatrixValue: Identifiable, Hashable {
    var id: UUID
    var value: Int
    init(_ value: Int) {
        self.value = value
        self.id = UUID()
    }
    
    static func == (lhs: MatrixValue, rhs: MatrixValue) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func + (lhs: MatrixValue, rhs: MatrixValue) -> MatrixValue {
        return MatrixValue(lhs.value + rhs.value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

struct MatrixModel: Identifiable {
    var id = UUID().uuidString
    var matrix: [[MatrixValue]]

    init(row: Int, column: Int) {
        precondition((1...3).contains(row), "Matrix row count must be between 1 and 3.")
        precondition((1...3).contains(column), "Matrix column count must be between 1 and 3.")
        matrix = (0..<row).map { _ in
            (0..<column).map { _ in MatrixValue(Int.random(in: 0...10)) }
        }
    }

    init(matrix: [[Int]]) {
        self.matrix = matrix.map { row in
            row.map { MatrixValue($0) }
        }
    }

    var row: Int {
        matrix.count
    }

    var column: Int {
        matrix.first?.count ?? 0
    }
}
