//
//  Untitled.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/10/20
//  
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("initialLaunch") var initialLaunch: Bool = false
    
    let imageString = [
        "onboarding1",
        "onboarding2",
        "onboarding3",
        "onboarding4",
        "onboarding5"
    ]
    let title: [String] = [
        "ハテナに入る数を入力しよう！",
        "メモモードを利用しよう！",
        "チュートリアルを見よう！",
        "ランキングに挑戦しよう！",
        "始めよう！"
    ]
    let description: [String] = [
        "正解すると、コンボ数が増える！",
        "途中計算が必要な場合は、メモモードに切り替えて途中式を書こう！",
        "画面左上のボタンから確認できる！行列が初めての人はまずここから！",
        "世界中の人とバトルしよう！\n(GameCenterがONになっている必要があります。)",
        "無限に続く行列計算の修行が、今始まります！"
    ]
    @State private var counter = 0
    var body: some View {
        VStack {
            pictureView(imageString[counter])
                .animation(.smooth, value: counter)
            Rectangle()
                .fill(.clear)
                .overlay {
                    VStack {
                        //                        Spacer()
                        Text(title[counter])
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .minimumScaleFactor(0.5)
                        Text(description[counter])
                            .multilineTextAlignment(.center)
                        //                            .padding([.leading,.trailing])
                        Spacer()
                        Button(action: {
                            buttonHandler()
                        }, label: {
                            Rectangle()
                                .fill(
                                    counter < 4 ? .gray : .blue
                                )
                                .frame(width: 350, height: 50)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 5)
                                )
                                .overlay() {
                                    if counter != 4 {
                                        Text("次へ")
                                            .foregroundStyle(.black)
                                    } else {
                                        Text("始める")
                                            .foregroundStyle(.white)
                                    }
                                }
                        })
                    }
                    .foregroundStyle(.white)
                }
            
        }
        
        .background() {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
        }
    }
    
    func buttonHandler() {
        if counter < 4 {
            counter = (counter+1)%5
        } else {
            withAnimation {
                initialLaunch = true
            }
        }
    }
    
    @ViewBuilder
    func pictureView(_ onboarding: String) -> some View {
        Rectangle()
            .fill(.clear)
            .overlay {
                switch counter {
                case 0:
                    Image("\(imageString[counter])")
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .animation(.smooth, value: counter)
                        .border(.red)
                case 1:
                    Image("\(imageString[counter])")
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .animation(.smooth, value: counter)
                        .border(.red)
                case 2:
                    Image("\(imageString[counter])")
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .animation(.smooth, value: counter)
                        .border(.red)
                case 3:
                    Image("\(imageString[counter])")
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .animation(.smooth, value: counter)
                        .border(.red)
                case 4:
                    Image("\(imageString[counter])")
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .animation(.smooth, value: counter)
                        .border(.red)
                default:
                    EmptyView()
                }
            }
            .frame(height: 500)
    }
}



#Preview {
    @Previewable @State var counter = 0
    ZStack {
        VStack {
            Text("value: \(counter)")
            Button("counter") {
                counter += 1
            }
        }
        OnboardingView()
    }
}
