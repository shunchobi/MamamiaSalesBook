//
//  MaterialContentView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/17.
//

import SwiftUI


///
///
//新しい商品の登録時、その商品の材料を選択する画面を表示するView
///
///
struct MaterialContentView: View {
    
    @State var materialCategolies: MaterialCategolies
    
    //選択した材料をこの配列へ追加
    @State private var selection: [aMaterial] = []

    //MaterialContentViewが閉じたかどうかを他Viewに知らせるためのpresentationMode
    @Environment(\.presentationMode) var presentation

    
    var body: some View {
        
        VStack{
            //材料のカテゴリーを表示
            List(materialCategolies.list) {categoly in
                Section(header : HStack{ Text("\(categoly.name)"); Spacer(); Text("原価").font(.subheadline)}){
                    //材料を表示
                    ForEach(categoly.materials, id: \.self){material in
                        //選択可能にするためのボタン
                        Button(action: {
                            selection.append(material)
                        }){
                            HStack{
                                Text("\(GetMyCount(me: material))個")
                                Spacer().frame(width: 15)
                                Text(material.name)
                                Spacer()
                                Text("\(material.cost)円")
             }}}}}
            .listStyle(SidebarListStyle())

            Spacer().frame(height: 20)
            Text("\(selection.count) つのアイテムを選択中")
            Spacer().frame(height: 20)
            
            HStack{
           Spacer()
                //最後に選択した材料を取り消す（操作を一つ戻すためのButto）
                Button(action: {
                    if selection.count == 0 {
                        return
                    }
                    selection.removeLast()
                }){
                    Text("一つ取り消す")
                        .foregroundColor(.red)
                        .imageScale(.small)
                        .frame(width: 110, height: 25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 2)
                        )
                }
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    CostInfo.cost = 0
                    CostInfo.myMaterials.removeAll()
                    //selected.costで選択された要素を取得
                    for selected in selection {
                        CostInfo.cost += selected.cost
                        CostInfo.myMaterials.append(selected)
                    }
                    self.presentation.wrappedValue.dismiss()
                }){
                    Text("決定")
                        .padding().frame(width: 90, height: 45)
                        .font(.system(size: 30.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                            // 枠線の色をブルーに指定
                            .stroke(Color.blue, lineWidth: 2)
                )}
                Spacer()
            }
            Spacer().frame(height: 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    
    //選択された材料が合計何回選択されているかの数を返すメソッド
    func GetMyCount(me: aMaterial) -> Int{
        var myCount: Int = 0
        let myName = me.name
        let myCost = me.cost
        
        for target in 0..<selection.count{
            let targetNmae = selection[target].name
            let targetCost = selection[target].cost
            if myName == targetNmae && myCost == targetCost{
                myCount += 1
            }
        }
        return myCount
    }
    
    
}

