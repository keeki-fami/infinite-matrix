//
//  TabViewPractice.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/22
//  
//

import SwiftUI

struct TabViewPractice: View {
    @State private var nowTab: Int = 0
    let stringHolder: [String] = ["a", "b", "c"]
    var body: some View {
        TabView(selection: $nowTab) {
            Tab("a", systemImage: "earth", value: 0) {
                ToyView(string: "a")
            }
            Tab("b", systemImage: "earth", value: 1) {
                ToyView(string: "b")
            }
            Tab("c", systemImage: "earth", value: 2) {
                ToyView(string: "c")
            }
        }
        .tabViewStyle(.page)
        .overlay {
            VStack {
                Rectangle()
                    .fill(.blue)
                Rectangle()
                    .fill(.clear)
            }
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    TabViewPractice()
}

struct ToyView: View {
    let string: String
    var body: some View {
        Rectangle()
        Rectangle()
            .fill(.white)
            .overlay {
                Text("string: \(string)")
            }
    }
}
