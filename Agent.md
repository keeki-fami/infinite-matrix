# 設計
MVVMによる行列出題アプリです。既存のコードを読み、それを元にコードを生成して下さい。
## Model
MatrixModelとMatrixProblemModelです。
- MatrixModel: n行m列の行列を表現します(n, mは、1から3の整数)
- MatrixProblemModel: 行列の問題を生成します。
###### MatrixModel : n行m列の行列を表現する。
```Swift
struct MatrixModel: Identifiable {
	var id = UUID().uuidString
	var matrix: [[Int]]

	// 計算型プロパティとして、値の不整合を防ぐ。
    var row: Int {
        matrix.count
    }
    var column: Int {
        matrix.first?.count ?? 0
    }
}
```
matrixmodelでは、行列を表現する。例として2行3列の行列は以下のInt型の配列である。
```
[[1,2,3], [3,4,5]]
```
###### MatrixProblemModel : 行列の加算, 減算, 乗算の問題を表現する。
```Swift
enum ProblemType {
	case add // 足し算
	case sub // 引き算
	case mul // 掛け算
}

struct MatrixProblemModel: Identifiable {
	var problemType: ProblemType // 行列の四則演算のタイプを指定する。
	var matrices: [MatrixModel] // 計算する行列を格納する。add, sub, mulであれば2つ。拡張に対応するため配列で表現する。例えば、行列式を実装したならば一つの行列が格納される。(複数の行列が追加される予定なのでmatrixの複数形。)
	var ansMatrix: MatrixModel // 答えとなる行列を格納する。
	var ansRow: Int // 答えとなる行列の要素の行を指定する。
	var ansColumn: Int // 答えとなる行列の要素の列を指定する。

	func genAnswer() {

	}
	func checkAnswer(answer: Int) -> Bool {
		// ansRowとansColumnを参考にansMatrixの値を見て、正解か否かを返す。
		// 正解: true, 不正解: false
	}
}
```
## ViewModel
#### ContentViewModelの概要
ContentView.swiftで実装するViewと対応するViewModel
MatrixModel.swiftとMatrixProblemModel.swiftで実装するModelとも対応する。

#### ContentViewModelの実装内容
###### .generate()
- 行列の問題を生成する。
	- ProblemTypeをランダムで生成する。
	- MatrixModelを生成する。（ProblemTypeに合わせて。）
	- MatrixProblemModelを初期化する。
		- 生成したMatrixModelに合わせて、答えを生成する。
		- ansRow, ansColumnもランダムで指定する。

###### .checkAnswer()
- 行列の問題の回答をチェックする。
	- MatrixProblemModelのcheckAnswerを走らせる。
		- 答えとなる行列の行と列(ansRow, ansColumn)と、ユーザが入力した数字を比べる
			- 正解していたら、trueを返す、そうでなければ、falseを返す。
	- trueなら、以下のことをする。
		- ContentViewModel.generateを走らせて次の問題を生成する。
		- コンボを1つ増やす。
		- 正解数を表すUserDefaults領域に格納された"success"がキーの値をひとつ増やす
	- そうでなければ、以下のことをする。
		- Viewにそれを伝える。すでに実装しているアニメーションが走る。
		- コンボを0にする。
		- 不正解数を表すUserDefaults領域に格納された"failure"がキーの値をひとつ増やす
###### .storeCombo()
- 現在のコンボ数をUserDefaultsに保存させる。
	- これを行うタイミングは、ScenePhaseで監視しているAppの状態による。
#### ContentViewModelの骨格
```Swift
@Observable
class ContentViewModel {

	var matrixProblem: MatrixProblemModel?
	var combo: Int
	var userInput: String

	init() {
		self.combo = UserDefaults.standard.set("combo") // userdefaultにcombo数を保持させている。
		self.userInput = "" // キーボードの制約から、ユーザは数字しか入力しないことが保証されている。
		self.generate() // matrixProblemを走らせて、問題を生成する。
	}

	func generate() {
		// matrixProblemへの格納は、ここで行う。
	}
	func checkAnswer() {
		// ユーザの入力であるuserInputをInt型にキャストする。
		// もしキャストできない場合はエラーメッセージを表示する。
		// MatrixProblemModelのcheckAnswerを呼び出す。
	}
	func storeCombo() {
		// UserDefautlsに現在のコンボ数を格納させる。
	}
}
```

## 制約
#### 行列演算の制約
- 生成する行列
	- 行数: 1から3に制限する。
	- 列数: 1から3に制限する。
	- 要素の数: 0から19の整数にする。
- 加算：2つの行列の行数と列数を一致させる。
- 減算：2つの行列の行数と列数を一致させる。
- 乗算：左の行列の列数と右の行列の行数を一致させる。
#### 実装上の制約
- Viewに行列計算や正誤判定のロジックを記述しない。
- ViewModelに行列演算の具体的な計算式を重複して実装しない。
- 既存のアニメーションを削除・変更しない。
- 既存のコードと矛盾する場合は、変更理由を明示する。
- 不要なファイルや抽象化を追加しない。
- Swiftの構文および既存プロジェクトのコーディング規約に従う。

上記内容に従って、ConetntViewModel.swift, MatrixModel.swift, MatrixProblemModel.swiftを作成することが完了条件です。まずは、変更予定、作成予定のファイルの内容、設計上の判断を、反映させる前に私に提示して下さい。
私に了承を得た後、実装内容を反映させること。
