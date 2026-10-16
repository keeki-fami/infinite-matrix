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
    @State var contentViewModel: ContentViewModel = .init()
    @State var generator = MatrixGenerator()
    @State private var memoView = PKCanvasView()
    @State var text = ""
    @State var updateAlert = false
    
    @AppStorage("failure") var failure: Int = 0
    @AppStorage("success") var success: Int = 0
    @AppStorage("combo") var combo_store: Int = 0
    
    @Environment(\.scenePhase) var scenePhase
    @State var gameCenterManager = GameCenterManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
//                    ScrollView {
                    VStack{
                        VStack {
                            HStack(spacing: 0) {
                                MatrixGridView(matrix: generator.matrixset.matrix1)
                                
                                OperatorText(type: generator.matrixset.calculateType)
                                
                                MatrixGridView(matrix: generator.matrixset.matrix2)
                            }
                            HStack {
                                cellText("=")
                                MatrixAnswerView(
                                    matrix: generator.matrixset.matrixAnswer,
                                    answerX: generator.matrixset.answerPointX,
                                    answerY: generator.matrixset.answerPointY
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Rectangle().fill(.clear).frame(width: 10, height: 20)
                    }
                    .overlay(alignment: .bottom) {
                        HStack {
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
                                Image(systemName: contentViewModel.isKeyboard ? "pencil.tip" : "plus.forwardslash.minus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        })
                        .buttonStyle(SubButtonStyle(onTouchUp: {
                            contentViewModel.togglePadView()
                            if contentViewModel.isKeyboard {
                                memoView.drawing = PKDrawing()
                            }
                        }))
                        .padding()
                    }
                    
                }
                .transition(.opacity)
                
                if contentViewModel.isKeyboard {
                    NumberPadView("submit", text: $generator.ansString, action: {
                        let result = generator.checkAnswer()
                        handleCheckAnswer(result: result)
                    })
                } else {
                    MemoView(memoView: $memoView, isKeyboard: $contentViewModel.isKeyboard)
                        .shadow(color: .gray.opacity(0.25), radius: 10, x: 0, y: -10)
                }
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
            .onChange(of: scenePhase, initial: false) {oldPhase, newPhase in
                
                if oldPhase == .background && newPhase == .active {
//                    contentViewModel.combo = combo_store
                    generator.generate()
                } else if newPhase == .active {
//                    contentViewModel.combo = combo_store
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
                        contentViewModel.combo = combo_store
                    }
                } else {
                    contentViewModel.combo = combo_store
                }
                
                contentViewModel.combo = combo_store
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(alignment: .bottom) {
                        Text("\(contentViewModel.combo)")
                            .font(.custom("", size: 20))
                            .contentTransition(.numericText(value: Double(contentViewModel.combo)))
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

                        Image(systemName: "info")
                    }
                }

            }
        }
    }
    
    func handleCheckAnswer(result: Bool) {
        generator.ansString = ""
        if result {
            // 正解したときに行う処理
            withAnimation {
                contentViewModel.combo += 1
            }
            combo_store = contentViewModel.combo
            success += 1
            generator.generate()
        } else {
            // 不正解になったときに行う処理
            // コンボをリセットする前に、コンボを送信する。
            let combo = UserDefaults.standard.integer(forKey: "combo")
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            
            failure += 1
            combo_store = 0
            contentViewModel.combo = 0
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

func storeData() {
    
}

struct OperatorText: View {
    var type: CalculateType
    var body: some View {
        switch type {
        case .add:
            Text("+")
                .padding()
        case .sub:
            Text("-")
                .padding()
        default:
            Text("")
        }
    }
}

#Preview {
    ContentView()
    //    buttonTest()
}
