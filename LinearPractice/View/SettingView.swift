//
//  SettingView.swift
//  LinearPractice
//  
//  Created by keeki-fami on 2026/11/01
//  
//

import SwiftUI

struct TestViewA: View {
    var body: some View {
        Text("aa")
    }
}
struct TestViewB: View {
    var body: some View {
        Text("bb")
    }
}

struct SettingView: View {
    @Environment(SettingViewModel.self) var settingViewModel
    var body: some View {
        @Bindable var setting = settingViewModel
        Form {
            Toggle("触覚フィードバックを使用", isOn: $setting.isOn)
            NavigationLink(destination: {
                SettingProblemTypeView()
            }, label: {
                Text("出題設定")
            })
        }
        .onDisappear() {
            UserDefaults.standard.set(setting.isOn, forKey: "isHaptics")
        }
    }
}

struct SettingProblemTypeView: View {
    @Environment(SettingViewModel.self) var settingViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        @Bindable var setting = settingViewModel
        VStack {
            Form {
                Toggle("足し算", isOn: $setting.add)
                Toggle("引き算", isOn: $setting.sub)
                Toggle("掛け算", isOn: $setting.mul)
                Toggle("行列式", isOn: $setting.determinant)
            }
            Button("変更する") {
                settingViewModel.storeProblemType()
                dismiss()
            }
        }
        .onAppear() {
            settingViewModel.fetchProblemType()
        }
    }
}

@Observable
class SettingViewModel {
    var isOn: Bool = true
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var add = true
    var sub = true
    var mul = true
    var determinant = true
    
    var dic: [ProblemType: Bool] = [
        .add: true,
        .sub: true,
        .mul: true,
        .determinant: true
    ]
    
}


extension SettingViewModel {
    
    func storeProblemType() {
        
        do {
            dic[.add] = add
            dic[.sub] = sub
            dic[.mul] = mul
            dic[.determinant] = determinant
            
            let data = try encoder.encode(dic)
            let jsonString = String(data: data, encoding: .utf8)
            UserDefaults.standard.set(jsonString, forKey: "problemTypeList")
        } catch {
            print("error")
            // TODO: show error message
        }
    }
    
    func fetchProblemType() {
        do {
            guard let userdefaults = UserDefaults.standard.string(forKey: "problemTypeList") else {
                return
            }
            
            let data = userdefaults.data(using: .utf8)!
            let json = try decoder.decode([ProblemType: Bool].self, from: data)
            self.dic = json
            
            add = dic[.add] ?? true
            sub = dic[.sub] ?? true
            mul = dic[.mul] ?? true
            determinant = dic[.determinant] ?? true
            
        } catch {
            print("error")
            // TODO: show error message
        }
    }
}

