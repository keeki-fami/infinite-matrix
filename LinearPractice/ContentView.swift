//
//  ContentView.swift
//  LinearPractice
//
//  Created by keeki-fami on 2026/06/23.
//

import SwiftUI
import AppVersionMonitorSwiftUI
import GameKit
import NumberPad
import PencilKit

extension Array {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct ContentView: View {
    @State var generator = MatrixGenerator()
    @State private var memoView = PKCanvasView()
    @State var text = ""
    @State var updateAlert = false
    @AppStorage("failure") var failure: Int = 0
    @AppStorage("success") var success: Int = 0
    @AppStorage("combo") var combo_store: Int = 0
    @Environment(\.scenePhase) var scenePhase
    @State var gameCenterManager = GameCenterManager.shared
    @State var selectedPhase = [0, 1]
    @State private var isKeyboard = true
    @State private var hSize1 = 0.0
    @State private var hSize2 = 0.0
    @State private var hSize3 = 0.0
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
//                    ScrollView {
                    VStack{
                        VStack {
                            HStack(spacing: 0) {
                                Image("left")
                                    .resizable()
                                    .frame(width: 10, height: hSize1)
                                MatrixGridView(matrix: generator.matrixset.matrix1)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                            .onChange(of: geometry.size.height) {
                                                withAnimation {
                                                    hSize1 = geometry.size.height
                                                }
                                                print(geometry.size)
                                            }
                                            .onAppear {
                                                hSize1 = geometry.size.height
                                            }
                                    })
                                Image("right")
                                    .resizable()
                                    .frame(width: 10, height: hSize1)
                                
                                if generator.matrixset.calculateType != .mul {
                                    operatorText
                                        .padding()
                                } else {
                                    Text(" ")
                                }
                                
                                Image("left")
                                    .resizable()
                                    .frame(width: 10, height: hSize2)
                                MatrixGridView(matrix: generator.matrixset.matrix2)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                            .onChange(of: geometry.size.height) {
                                                withAnimation {
                                                    hSize2 = geometry.size.height
                                                }
                                                print(geometry.size)
                                            }
                                            .onAppear {
                                                hSize2 = geometry.size.height
                                            }
                                    })
                                Image("right")
                                    .resizable()
                                    .frame(width: 10, height: hSize2)
                            }
                            HStack {
                                cellText("=")
                                Image("left")
                                    .resizable()
                                    .frame(width: 10, height: hSize3)
                                MatrixAnswerView(
                                    matrix: generator.matrixset.matrixAnswer,
                                    answerX: generator.matrixset.answerPointX,
                                    answerY: generator.matrixset.answerPointY
                                )
                                .background(GeometryReader { geometry in
                                    Color.clear
                                        .onChange(of: geometry.size.height) {
                                            withAnimation {
                                                hSize3 = geometry.size.height
                                            }
                                            print(geometry.size)
                                        }
                                        .onAppear {
                                            hSize3 = geometry.size.height
                                        }
                                })
                                Image("right")
                                    .resizable()
                                    .frame(width: 10, height: hSize3)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Rectangle().fill(.clear).frame(width: 10, height: 20)
                    }
                    .overlay(alignment: .bottom) {
                        HStack {
//                            Text("? = ")
                            Text("\(generator.ansString.isEmpty ? "   " : generator.ansString)")
                                .font(Font.title)
                                .background(Color(red: 217/255, green: 217/255, blue: 217/255))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding()
                        .keyframeAnimator(initialValue: 0.0, trigger: generator.checkAnimation) { content, value in
                            content.offset(x: value)
                        } keyframes: { _ in
                            KeyframeTrack {
                                MoveKeyframe(10.0)
                                LinearKeyframe(-10.0, duration: 0.1)
                                LinearKeyframe(5.0, duration: 0.1)
                                LinearKeyframe(-5.0, duration: 0.1)
                                LinearKeyframe(2.0, duration: 0.1)
                                LinearKeyframe(-2.0, duration: 0.1)
                                LinearKeyframe(1.0, duration: 0.1)
                                LinearKeyframe(-1.0, duration: 0.1)
                                LinearKeyframe(0.5, duration: 0.1)
                                LinearKeyframe(-0.5, duration: 0.1)
                            }
                            
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: {
                            
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 217/255, green: 217/255, blue: 217/255))
                                    .frame(width: 40, height: 40)
                                Image(systemName: isKeyboard ? "pencil.tip" : "plus.forwardslash.minus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        })
                        .buttonStyle(SubButtonStyle(onTouchUp: {
                            isKeyboard.toggle()
                            if isKeyboard {
                                memoView.drawing = PKDrawing()
                            }
                        }))
                        .padding()
                    }
                    
                }
                .transition(.opacity)
                
                if isKeyboard {
                    NumberPadView("submit", text: $generator.ansString, action: {
                        let result = generator.checkAnswer()
                        handleCheckAnswer(result: result)
                    })
                } else {
                    MemoView(memoView: $memoView, isKeyboard: $isKeyboard)
                        .shadow(color: .gray.opacity(0.25), radius: 10, x: 0, y: -10)
                }
//                KeyBoard(generator: generator)
            }
            .alert(
                "最新版があります",
                isPresented: $updateAlert
            ) {
                Button(role: .cancel) {
                    
                } label : {
                    Text("キャンセル")
                }
                Button(role: .confirm) {
                    if let url = URL(string: "https://apps.apple.com/jp/app/%E7%84%A1%E9%99%90%E8%A1%8C%E5%88%97%E8%A8%88%E7%AE%97/id6785983550") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                } label: {
                    Text("AppStoreに移動")
                }
            } message: {
                Text("AppStoreに移動して最新版をインストールします")
            }
            .appVersionMonitor(id: 6785983550) { status in
                switch status {
                case .updateAvailable:
                    updateAlert = true
                default:
                    updateAlert = false
                }
                
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if oldPhase == .background && newPhase == .active {
                    generator.combo = combo_store
                    generator.generate()
                } else if newPhase == .active {
                    generator.combo = combo_store
                    GKAccessPoint.shared.isActive = false
                }
                
                // active以外の状態に遷移する時、コンボを送信する
                if oldPhase == .active && newPhase != .active {
                    let comboNumber = UserDefaults.standard.integer(forKey: "combo")
                    gameCenterManager.submitScore(comboNumber, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                }
            }
            .onAppear() {
                gameCenterManager.initializeLocalPlayer()
                if gameCenterManager.isAuthenticated {
                    Task {
                        await gameCenterManager.checkDuration()
                        generator.combo = combo_store
                    }
                } else {
                    generator.combo = combo_store
                }
                generator.combo = combo_store
                    
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(alignment: .bottom) {
                        Text("\(generator.combo)")
                            .font(.custom("", size: 20))
                            .contentTransition(.numericText(value: Double(generator.combo)))
                        Text("combo")
                    }
                    .fixedSize(horizontal: true, vertical: false)

                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        NavigationLink(destination: {
                            ProfileView(manager: $gameCenterManager)
                                .onAppear() {
                                    let data = UserDefaults.standard.integer(forKey: "success")
                                    gameCenterManager.submitScore(data, to: "com.LinearPractice.keekifami.HighScore")
                                    let comboNumber = UserDefaults.standard.integer(forKey: "combo")
                                    gameCenterManager.submitScore(comboNumber, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                                }
                        }, label: {
                            Label("プロフィール", systemImage: "person")
                        })
                        
                        Button(action: {
                            let data = UserDefaults.standard.integer(forKey: "success")
                            gameCenterManager.submitScore(data, to: "com.LinearPractice.keekifami.HighScore")
                            let comboNumber = UserDefaults.standard.integer(forKey: "combo")
                            gameCenterManager.submitScore(comboNumber, to: "com.LinearPractice.keekifami.WeeklyComboRanking")
                            
                            gameCenterManager.showLeaderboards()
                        }, label: {
                            Label("ランキング", systemImage: "trophy")
                        })
                        
                    } label: {
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(Color(red: 217/255, green: 217/255, blue: 217/255))
//                            .frame(width: 40, height: 40)
//                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 2)
//                            .overlay {
//                                Image(systemName: "info")
//                            }
                        Image(systemName: "info")
                    }
                }
//                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
    var operatorText: Text {
        var op: String {
            switch generator.matrixset.calculateType {
            case .add: return "+"
            case .sub: return "-"
            default: return ""
            }
        }
        return Text(op)
    }
    
    func handleCheckAnswer(result: Bool) {
        generator.ansString = ""
        if result {
            // 正解したときに行う処理
            withAnimation {
                generator.combo += 1
            }
            combo_store = generator.combo
            success += 1
            generator.generate()
        } else {
            // 不正解になったときに行う処理
            // コンボをリセットする前に、コンボを送信する。
            let combo = UserDefaults.standard.integer(forKey: "combo")
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            
            failure += 1
            combo_store = 0
            generator.combo = 0
            generator.ansString = ""
//            generator.checkAnimation.toggle()
            
        }
    }
}
struct SubButtonStyle: ButtonStyle {
//    let onTouchDown: () -> Void
    let onTouchUp: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
            .foregroundColor(.black)
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
            .shadow(color: .black.opacity( configuration.isPressed ? 0 : 0.5 ), radius: 1, x: 0, y: 2)
            .onChange(of: configuration.isPressed) {before, after in
                if before {
                    onTouchUp()
                }
            }
    }
}

#Preview {
    ContentView()
    //    buttonTest()
}
