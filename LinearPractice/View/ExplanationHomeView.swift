import SwiftUI

struct ExplanationHomeView: View {
    private let prerequisites = ["前提知識1", "前提知識2"]
    private let calculations = ["行列の足し算", "行列の引き算", "行列の掛け算"]

    var body: some View {
        List {
            Section(header: Text("前提知識")) {
                ForEach(prerequisites, id: \.self) { title in
                    NavigationLink(title) {
                        Text(title)
                            .navigationTitle(title)
                    }
                }
            }

            Section(header: Text("計算")) {
                ForEach(calculations, id: \.self) { title in
                    NavigationLink(title) {
                        Text(title)
                            .navigationTitle(title)
                    }
                }
            }
        }
        .navigationTitle("解説")
    }
}

#Preview {
    ExplanationHomeView()
}
