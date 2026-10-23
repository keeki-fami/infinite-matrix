import SwiftUI

enum ExplanationLesson: String, CaseIterable, Hashable, Identifiable {
    case rowsAndColumns = "行と列"
    case elementPosition = "要素の数え方"
    case addition = "行列の足し算"
    case subtraction = "行列の引き算"

    var id: Self { self }

    var section: String {
        switch self {
        case .rowsAndColumns, .elementPosition:
            return "前提知識"
        case .addition, .subtraction:
            return "計算"
        }
    }
    
    var pictures: [String] {
        switch self {
        case .rowsAndColumns:
            return [
                "tutorial_rowcolumn_1",
                "tutorial_rowcolumn_1",
                "tutorial_rowcolumn_2",
                "tutorial_rowcolumn_3",
                "tutorial_rowcolumn_4",
                "tutorial_rowcolumn_5",
                "tutorial_rowcolumn_6",
                "tutorial_rowcolumn_7",
                "tutorial_rowcolumn_8",
            ]
        case .elementPosition:
            return [
                "tutorial_element1",
                "tutorial_element2",
                "tutorial_element3",
                "tutorial_element4",
                "tutorial_element5",
                "tutorial_element6",
                "tutorial_element7",
            ]
        case .addition:
            return [
                "tutorial_add_1",
                "tutorial_add_3",
                "tutorial_add_2",
                "tutorial_add_3",
                "tutorial_add_4",
                "tutorial_add_5",
                "tutorial_add_6",
            ]
        case .subtraction:
            return [
                "tutorial_sub_1",
                "tutorial_sub_3",
                "tutorial_sub_2",
                "tutorial_sub_3",
                "tutorial_sub_4",
                "tutorial_sub_5",
                "tutorial_sub_6",
            ]
        default:
            return [
                "tutorial_add_1",
                "tutorial_add_1",
                "tutorial_add_2",
                "tutorial_add_3",
                "tutorial_add_4",
                "tutorial_add_5",
                "tutorial_add_6",
            ]
        }
    }

    var slides: [String] {
        switch self {
        case .rowsAndColumns:
            return [
                "今画面に見えているのは**行列**です。",
                "行列には、**行**と**列**という数え方があります。",
                "行は横方向です。",
                "列は縦方向です。",
                "上の行列は、横方向に数えると２個あります。",
                "したがって、２行あると言えます。",
                "上の行列は、縦方向に数えると３個あります。",
                "したがって、３列あると言えます。",
                "この行列は、２行３列の行列です。"
            ]
        case .elementPosition:
            return [
                "３行２列の行列を考えます。",
                "「３行２列」が何かわからない人は、「行と列」を見てください。",
                "行列では、各数字を要素と言います。",
                "図のハイライトされている部分の要素の場所を人に伝えるときは、どうすれば良いでしょうか。",
                "ハイライトされている数字は、１行目にあります。",
                "また、列で言うと２列目にあります。",
                "したがって、１行２列目にある要素、と表現することができます。"
            ]
        case .addition:
            return [
                "行列の足し算は難しそうに見えて、実は簡単です。",
                "行列の同じ位置にある要素同士を足せば良いです。",
                "行列の「要素」がわからない人は、「要素の数え方」を見てください。",
                "回答の１行２列の部分を求めてみましょう。",
                "１行２列目の要素を求めるには、行列の１行２列の要素同士を足しましょう。",
                "８＋５です。",
                "答えは１３です。"
            ]
        case .subtraction:
            return [
                "行列の引き算は難しそうに見えて、実は簡単です。",
                "行列の同じ位置にある要素同士を引けば良いです。",
                "行列の「要素」がわからない人は、「要素の数え方」を見てください。",
                "回答の１行１列の部分を求めてみましょう。",
                "１行１列目の要素を求めるには、行列の１行１列の要素同士の引き算をしましょう。",
                "１−１です。",
                "答えは０です。"
            ]
        }
    }

}

enum ExplanationDestination: Hashable {
    case home
    case lesson(ExplanationLesson)
    case quiz(ExplanationLesson)
}

struct ExplanationHomeView: View {
    var body: some View {
        List {
            ForEach(["前提知識", "計算"], id: \.self) { section in
                Section(header: Text(section)) {
                    ForEach(ExplanationLesson.allCases.filter { $0.section == section }) { lesson in
                        NavigationLink(value: ExplanationDestination.lesson(lesson)) {
                            Text(lesson.rawValue)
                        }
                    }
                }
            }
        }
        .navigationTitle("解説")
    }
}

struct ExplanationLessonView: View {
    let lesson: ExplanationLesson
    @State private var currentPage = 0
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                Text("\(currentPage+1)/\(lesson.slides.count)")
                    .foregroundStyle(.gray)
                Image("\(lesson.pictures[currentPage])")
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height * 0.42)

                Rectangle()
                    .fill(Color.indigo.opacity(0.08))
                    .overlay {
                        Text(LocalizedStringKey(lesson.slides[currentPage]))
                            .font(.title3.weight(.medium))
                            .multilineTextAlignment(.center)
                            .padding(24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: geometry.size.height * 0.34)

                Button {
                    withAnimation(.easeInOut) {
                        if currentPage == lesson.slides.count - 1 {
                            dismiss()
                        } else {
                            currentPage = (currentPage + 1) % lesson.slides.count
                        }
                    }
                } label: {
                    Text("次へ")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.indigo)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
        }
        .navigationTitle(lesson.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExplanationQuizView: View {
    let lesson: ExplanationLesson

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.18))
            .overlay {
                Text("\(lesson.rawValue)の確認問題を配置")
                    .foregroundStyle(.secondary)
            }
            .padding()
        .navigationTitle("確認問題")
        .navigationBarTitleDisplayMode(.inline)
    }
}
