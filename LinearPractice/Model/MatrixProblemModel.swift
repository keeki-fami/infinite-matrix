//
//  MatrixProblemModel.swift
//  LinearPractice
//

import Foundation

enum ProblemType: CaseIterable {
    case add
    case sub
    case mul
}

struct MatrixProblemModel: Identifiable {
    var id: String
    var problemType: ProblemType
    var matrices: [MatrixModel]
    var ansMatrix: MatrixModel?
    var ansRow: Int?
    var ansColumn: Int?
    
    init(problemType: ProblemType, matricies: [MatrixModel], ansMatrix: MatrixModel? = nil, ansRow: Int? = nil, ansColumn: Int? = nil) {
        self.id = UUID().uuidString
        self.matrices = matricies
        self.problemType = problemType
        self.ansMatrix = ansMatrix
        self.ansRow = ansRow
        self.ansColumn = ansColumn
    }

    static func generate() -> MatrixProblemModel {
        guard let problemType = ProblemType.allCases.randomElement() else {
            preconditionFailure("At least one problem type must be available.")
        }

        let leftRows: Int
        let leftColumns: Int
        let rightRows: Int
        let rightColumns: Int

        // 次数による行数, 列数生成
        switch problemType {
        case .add, .sub:
            leftRows = Int.random(in: 1...3)
            leftColumns = Int.random(in: 1...3)
            rightRows = leftRows
            rightColumns = leftColumns
        case .mul:
            let sharedDimension = Int.random(in: 1...3)
            leftRows = Int.random(in: 1...3)
            leftColumns = sharedDimension
            rightRows = sharedDimension
            rightColumns = Int.random(in: 1...3)
        }
        
        var problem = MatrixProblemModel(
            problemType: problemType,
            matricies: [
                MatrixModel(row: leftRows, column: leftColumns),
                MatrixModel(row: rightRows, column: rightColumns)
            ],
        )
        
        problem.genAnswer()
        return problem
    }

    mutating func genAnswer() {
        var answer: [[Int]]
        
        print(problemType)

        switch problemType {
        case .add:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.row == right.row && right.column == left.column,
                "Addition requires matrices of equal dimensions."
            )
            
            let row = left.row
            let column = left.column
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: column
                ),
                count: row
            )
            
            for i in 0..<row {
                for j in 0..<column {
                    answer[i][j] = left.matrix[i][j].value + right.matrix[i][j].value
                }
            }
            
        case .sub:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.row == right.row && right.column == left.column,
                "Addition requires matrices of equal dimensions."
            )
            
            let row = left.row
            let column = left.column
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: column
                ),
                count: row
            )
            
            for i in 0..<row {
                for j in 0..<column {
                    answer[i][j] = left.matrix[i][j].value - right.matrix[i][j].value
                }
            }
        case .mul:
            precondition(matrices.count == 2, "A problem must contain exactly two matrices.")
            let left = matrices[0]
            let right = matrices[1]
            
            precondition(
                left.column == right.row,
                "Multiplication requires the left column count to equal the right row count."
            )
            
            answer = Array(
                repeating: Array(
                    repeating: 0,
                    count: right.column
                ),
                count: left.row
            )
            var num = 0
            for i in 0..<left.row {
                for j in 0..<right.column {
                    num = 0
                    for k in 0..<left.column {
                        num += left.matrix[i][k].value * right.matrix[k][j].value
                    }
                    answer[i][j] = num
                }
            }
        }

        self.ansMatrix = MatrixModel(matrix: answer)
        self.ansRow = Int.random(in: 0..<(ansMatrix!.row))
        self.ansColumn = Int.random(in: 0..<ansMatrix!.column)
        
        
    }

    func checkAnswer(answer: Int) -> Bool {
        precondition(
            ansRow != nil && ansColumn != nil,
            "答えの行, 列が指定されていません。"
        )
        
        precondition(
            ansMatrix != nil && ansMatrix!.row >= ansRow! && ansMatrix!.column >= ansColumn!,
            "解答の行列が指定されていません。"
        )
        
        return ansMatrix!.matrix[ansRow!][ansColumn!].value == answer
    }

    private func isRectangular(_ matrix: [[Int]]) -> Bool {
        guard let firstRow = matrix.first, !firstRow.isEmpty else {
            return false
        }
        return matrix.allSatisfy { $0.count == firstRow.count }
    }
}
