
import SwiftUI

// MARK: 正誤判定に関連のある機能
extension ContentViewModel {
    var isBubbleAnimation: Bool = false
    let achievementSet: Set<Int> = [10, 50, 77, 100, 200, 500, 777, 1000]
    var hapticGenerator: UINotificationFeedbackGenerator? = nil
    // 回答確認。それに伴うcomboの更新処理など、一連の処理をまとめる。
    func checkAnswer() async {
        var matrixproblem = nowProblem == .problem1 ? matrixProblem1 : matrixProblem2
        guard let answer = Int(userInput) else {
            inputError = "数字を入力してください。"
            checkAnimation.toggle()
            return
        }
        
        guard let matrixproblem else {
            preconditionFailure("A problem must be generated before checking an answer.")
        }

        inputError = nil
        let result = matrixproblem.checkAnswer(answer: answer)
        
        if result {
            self.userInput = ""
            if nowProblem == .problem1 {
                self.isSuccess1 = true
            } else {
                self.isSuccess2 = true
            }
//            var player = try? AVAudioPlayer(data: NSDataAsset(name: "determine")!.data)
//            player?.play()
            
            hapticGenerator = UINotificationFeedbackGenerator()
            hapticGenerator?.prepare()
            hapticGenerator?.notificationOccurred(.success)
            hapticGenerator = nil
            
            withAnimation(.easeOut(duration: 0.3)) {
                combo += 1
            }
            if combo % 10 == 0 && combo != 0 {
                isBubbleAnimation.toggle()
            }
            
            if achievementSet.contains(combo) {
                GameCenterManager.shared.updateAchievement(for: combo)
            }
            
            success += 1
            
            // TODO: delayを入れる？
            
            Task {
                try? await Task.sleep(nanoseconds: 200000000)
                withAnimation() {
                    self.nowProblem.toggle()
                } completion: {
                    if self.nowProblem == .problem1 {
                        self.isSuccess2 = false
                    } else {
                        self.isSuccess1 = false
                    }
                    self.generate()
                }
            }
        } else {
            // GameCenterに送信
            GameCenterManager.shared.submitScore(combo, to: "com.LinearPractice.keeki.WeeklyComboRanking")
            combo = 0
            failure += 1
            checkAnimation.toggle()
            self.userInput = ""
        }

    }
}
