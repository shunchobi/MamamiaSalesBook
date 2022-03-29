//
//  MaterialContentView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/17.
//

import SwiftUI



struct MaterialContentView: View {
    
    @State var materialCategolies : MaterialCategolies
//    @State private var selection: Set<aMaterial> = Set()
    @State private var selection: [aMaterial] = []

//    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation
//    var costclass = Cost()

    var body: some View {
        
        VStack{
            List(materialCategolies.list) {categoly in
                Section(header : HStack{ Text("\(categoly.name)"); Spacer(); Text("原価").font(.subheadline)}){
                    ForEach(categoly.materials, id: \.self){material in
                        
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
//            .environment(\.editMode, .constant(.active))

            Spacer().frame(height: 20)
            Text("\(selection.count) つのアイテムを選択中")
            Spacer().frame(height: 20)
            
            HStack{
           Spacer()
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
                            // 枠線の色をブルーに指定
                            .stroke(Color.red, lineWidth: 2)
                        )
                }
                Spacer().frame(width: 20)
                Button(action: {
                    Cost.num = 0
                    Cost.myMaterials.removeAll()
                    //selected.costの形で選択された要素を取得
                    for selected in selection {
                        Cost.num += selected.cost
                        Cost.myMaterials.append(selected)
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




//struct MaterialContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MaterialContentView()
//    }
//}
