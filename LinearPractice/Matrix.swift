////
////  Matrix.swift
////  LinearPractice
////
////  Created by keeki-fami on 2026/06/23.
////
//
//import SwiftUI
//
//
//// 行列の計算の種類
//enum CalculateType {
//    case add
//    case sub
//    case mul
//}
//
//struct MatrixValue: Identifiable, Hashable {
//    var value: Int
//    var id = UUID()
//}
//
//
//struct Matrix: Hashable {
//    var rowDim = 3
//    var colDim = 3
//    var matrix: [[MatrixValue]] = Array(repeating: [.init(value: 0), .init(value: 0), .init(value: 0), .init(value: 0), .init(value: 0)], count: 5)
//}
//
//
//struct MatrixSet: Identifiable, Hashable {
//    var id = UUID()
//    var matrix1: Matrix = .init()
//    var matrix2: Matrix = .init()
//    var matrixAnswer: Matrix = .init()
//    var calculateType: CalculateType = .add
//    var answerPointX: Int = 0
//    var answerPointY: Int = 0
//}
//
//// 行列として表示する数値、回答の生成、正誤判定
//@Observable
//class MatrixGenerator {
////    var rowDim = 3
////    var colDim = 3
////    var matrix1: Matrix = .init()
////    var matrix2: Matrix = .init()
////    var matrixAnswer: Matrix = .init()
////    var calculateType: CalculateType = .add
//    var matrixset: MatrixSet = .init()
////    var answerPointX: Int = 0
////    var answerPointY: Int = 0
//    var ansString: String = ""
//    var checkAnimation = false
//    var successCounter = 0
//    
//    init() {
//        self.generate()
//    }
//    
//    func generate() {
//        
//        let row1: Int
//        let row2: Int
//        let col1: Int
//        let col2: Int
//        var temp_matrix1: [[MatrixValue]] = []
//        var temp_matrix2: [[MatrixValue]] = []
//        
//        // determine type
//        let type = Int.random(in: 0...2)
//        let calculatetype: CalculateType
//        if type == 0 {
//            calculatetype = .add
//        } else if type == 1 {
//            calculatetype = .sub
//        } else {
//            calculatetype = .mul
//        }
//        
//        let num1 = Int.random(in: 1...3)
//        let num2 = Int.random(in: 1...3)
//        
//        if calculatetype == .add || calculatetype == .sub {
//            row1 = num1
//            row2 = num1
//            col1 = num2
//            col2 = num2
//        } else {
//            col1 = num1
//            row2 = num1
//            row1 = num2
//            col2 = num2
//        }
//        
//        for _ in 0..<row1 {
//            var row: [MatrixValue] = []
//            for _ in 0..<col1 {
//                row.append(MatrixValue(value: Int.random(in: 0...10)))
//            }
//            temp_matrix1.append(row)
//        }
//        
//        for _ in 0..<row2 {
//            var row: [MatrixValue] = []
//            for _ in 0..<col2 {
//                row.append(MatrixValue(value: Int.random(in: 0...10)))
//            }
//            temp_matrix2.append(row)
//        }
////        calculateType = calculatetype
////        matrix1 = Matrix(rowDim: row1, colDim: col1, matrix: temp_matrix1)
////        matrix2 = Matrix(rowDim: row2, colDim: col2, matrix: temp_matrix2)
//        generateAnswer(
//            matrix1: temp_matrix1,
//            matrix2: temp_matrix2,
//            calculateType: calculatetype,
//            row1: row1,
//            row2: row2,
//            col1: col1,
//            col2: col2
//        )
//    }
//    
//    func generateAnswer(matrix1: [[MatrixValue]], matrix2: [[MatrixValue]], calculateType: CalculateType, row1: Int, row2: Int, col1: Int, col2: Int) {
//        var matrixanswer: [[MatrixValue]] = []
//        switch calculateType {
//        case .add:
//            matrixanswer = generateAddAnswer(
//                matrix1: matrix1,
//                matrix2: matrix2,
//                calculateType: calculateType,
//                row1: row1,
//                row2: row2,
//                col1: col1,
//                col2: col2
//            )
//        case .sub:
//            matrixanswer = generateSubAnswer(
//                matrix1: matrix1,
//                matrix2: matrix2,
//                calculateType: calculateType,
//                row1: row1,
//                row2: row2,
//                col1: col1,
//                col2: col2
//            )
//        case .mul:
//            matrixanswer = generateMulAnswer(
//                matrix1: matrix1,
//                matrix2: matrix2,
//                calculateType: calculateType,
//                row1: row1,
//                row2: row2,
//                col1: col1,
//                col2: col2
//            )
//        default:
//            break
//        }
//        
//        
//        let answerpointX = Int.random(in: matrixanswer.indices)
//        let answerpointY = Int.random(in: matrixanswer[answerpointX].indices)
//        
//
//        withAnimation {
//            matrixset = MatrixSet(
//                matrix1: Matrix(rowDim: row1, colDim: col1, matrix: matrix1),
//                matrix2: Matrix(rowDim: row2, colDim: col2, matrix: matrix2),
//                matrixAnswer: Matrix(rowDim: matrixanswer.count, colDim: matrixanswer[0].count, matrix: matrixanswer),
//                calculateType: calculateType,
//                answerPointX: answerpointX,
//                answerPointY: answerpointY
//            )
//        }
//    }
//    
//    func generateAddAnswer(matrix1: [[MatrixValue]], matrix2: [[MatrixValue]], calculateType: CalculateType, row1: Int, row2: Int, col1: Int, col2: Int) -> [[MatrixValue]] {
//        if row1 != row2 || col1 != col2 {
//            // TODO: エラー
//            print("ダメです")
//        }
//        
//        var matrix: [[MatrixValue]] = []
//        for i in 0..<row1 {
//            var row: [MatrixValue] = []
//            for j in 0..<col1 {
//                row.append(MatrixValue(value: matrix1[i][j].value + matrix2[i][j].value))
//            }
//            matrix.append(row)
//        }
//        return matrix
////        matrixAnswer = .init(rowDim: matrix1.rowDim, colDim: matrix1.colDim, matrix: matrix)
//    }
//    
//    func generateSubAnswer(matrix1: [[MatrixValue]], matrix2: [[MatrixValue]], calculateType: CalculateType, row1: Int, row2: Int, col1: Int, col2: Int) -> [[MatrixValue]] {
//        if row1 != row2 || col1 != col2 {
//            // TODO: エラー
//            print("ダメです")
//        }
//        
//        var matrix: [[MatrixValue]] = []
//        for i in 0..<row1 {
//            var row: [MatrixValue] = []
//            for j in 0..<col1 {
//                row.append(MatrixValue(value: matrix1[i][j].value - matrix2[i][j].value))
//            }
//            matrix.append(row)
//        }
//        return matrix
////        matrixAnswer = .init(rowDim: matrix1.rowDim, colDim: matrix1.colDim, matrix: matrix)
//    }
//    
//    func generateMulAnswer(matrix1: [[MatrixValue]], matrix2: [[MatrixValue]], calculateType: CalculateType, row1: Int, row2: Int, col1: Int, col2: Int) -> [[MatrixValue]] {
//        if col1 != row2 {
//            // TODO: エラー
//            print("ダメです")
//        }
//        
//        let row = row1
//        let col = col2
//        
//        var matrix: [[MatrixValue]] = []
//        for i in 0..<row {
//            var row: [MatrixValue] = []
//            for j in 0..<col {
//                var num = 0
//                for k in 0..<col1 {
//                    num += matrix1[i][k].value * matrix2[k][j].value
//                }
//                row.append(MatrixValue(value: num))
//            }
//            matrix.append(row)
//        }
//        return matrix
////        matrixAnswer = .init(rowDim: matrix1.rowDim, colDim: matrix2.colDim, matrix: matrix)
//    }
//    
//    func checkAnswer() -> Bool{
//        print(ansString)
//        let x = matrixset.answerPointX
//        let y = matrixset.answerPointY
//        print(matrixset.matrixAnswer.matrix[x][y].value)
//        if let ans = Int(ansString) {
//            if ans == matrixset.matrixAnswer.matrix[x][y].value {
//                print(ans)
//                UINotificationFeedbackGenerator().notificationOccurred(.success)
//                return true
//            } else {
//                checkAnimation.toggle()
//                return false
//            }
//        } else {
//            return false
//        }
//    }
//    
//
//}
