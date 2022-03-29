//
//  MaterialManegementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


struct MaterialManegementView: View {
    
    
    @ObservedObject var materialCategolies : MaterialCategolies
    @State var onAlertForAddCategoly = false
    @State var onAlertForAddMaterial = false
    @State var newCategolyName = ""
    @State var newMaterialName = ""
    @State var newMaterialCost = ""
    @State var actionedCategolyButton = ""
    @State var Index = 0
    
    @FocusState var focus:Bool
    @State var isEnableCategolyAddButton : Bool = false
    @State var isEnableMaterialAddButton : Bool = false

    @State var willDeleteCategoly: aMaterialCategoly? = nil
    @State var onAlertForDeleteCategoly: Bool = false
    @State var isShowingView: Bool = false
    
    
    var body: some View {
        
        ZStack {
          NavigationView {
            List {
                ForEach (materialCategolies.list){categoly in
                    Section(header : HStack{
                        Text("\(categoly.name)")
                        Button("✖️", action:{
                            willDeleteCategoly = categoly
                            print(categoly.index)
                            onAlertForDeleteCategoly = true
                        })
                            .foregroundColor(.red);
                        Spacer()
                        Text("原価")
                            .font(.subheadline)
                    },
                            footer : HStack{
                        Spacer();
                        Button("Add", action:{
//                            categolyIndex = categoly.index
                            actionedCategolyButton = categoly.name
                            self.onAlertForAddMaterial.toggle()
                        })
                            .foregroundColor(.blue);
                        Spacer()
                    })
                    {
                        ForEach(categoly.materials) {material in
                            HStack{
                                Text(material.name)
                                Spacer()
                                Text("\(material.cost)円")
                            }
                        }
                        .onDelete { indexSet in
                            materialCategolies.list[categoly.index].materials.remove(atOffsets: indexSet)
                            materialCategolies.SaveMaterialData()
                        }
                }
              }
                //Delete Categoly
//                .onDelete { indexSet in
//                        materialCategolies.list.remove(atOffsets: indexSet)
//                    for i in 0..<materialCategolies.list.count{
//                        materialCategolies.list[i].ChangeIndex(_index: materialCategolies.list.count - 1)
//                        materialCategolies.SaveMaterialData()
//                    }
//                }
            }
            .navigationTitle("材料管理")
            .listStyle(SidebarListStyle())
            .toolbar {Button(action:{ self.onAlertForAddCategoly.toggle() }){ Text("カテゴリー追加＋") }}
          }
          .navigationBarTitleDisplayMode(.inline)
          .navigationBarBackButtonHidden(false)
            
            
            
            
            if onAlertForDeleteCategoly {
                NavigationView{
                    ZStack() {
                            Rectangle()
                            .foregroundColor(.white)
                            VStack {
                                Text("「\(willDeleteCategoly!.name)」")
                                Text("本当にカテゴリーを消しますか？")
                               Spacer()
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        let deleteName: String = willDeleteCategoly!.name
                                        for i in 0..<materialCategolies.list.count{
                                            let targetName = materialCategolies.list[i].name
                                            if targetName == deleteName{
                                                materialCategolies.list.remove(at: i)
                                                break
                                            }
                                        }
                                        for i in 0..<materialCategolies.list.count{
                                            materialCategolies.list[i].ChangeIndex(_index: materialCategolies.list.count - 1)
                                        }
                                        materialCategolies.SaveMaterialData()
                                        self.onAlertForDeleteCategoly.toggle()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForDeleteCategoly.toggle()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddCategolyButtonAvariable()
//                        }

                    }
                .frame(width: 300, height: 180,alignment: .center)
                .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }


            
            
    
            if onAlertForAddMaterial {
                NavigationView{
                    ZStack() {
                            Rectangle()
                            .foregroundColor(.white)
                            VStack {
                                Spacer().frame(height: 15)
                                TextField("新しい材料名",text: $newMaterialName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding().frame(height: 30)
                                Spacer().frame(height: 20)
                                TextField("仕入れ価格",text: $newMaterialCost)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding().frame(height: 30)
                                    .keyboardType(.numberPad)
                                Spacer().frame(height: 30)
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        for i in 0..<materialCategolies.list.count{
                                            if(materialCategolies.list[i].name == self.actionedCategolyButton){
                                                let material = aMaterial(_name:newMaterialName, _cost:Int(newMaterialCost) ?? 0)
//                                                materialCategolies.list[i].materials.append(material)
                                                materialCategolies.AddMaterial(index: i, material: material)
                                            }
                                        }
                                        self.onAlertForAddMaterial.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newMaterialName = ""
                                        newMaterialCost = ""
                                    }
                                    .frame(width: 100, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddMaterialButtonAvariable)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForAddMaterial.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newMaterialName = ""
                                        newMaterialCost = ""
                                    }
                                    .frame(width: 130, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddMaterialButtonAvariable()
//                        }
                    }
                    .frame(width: 300, height: 200,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                    .focused(self.$focus)
                    .toolbar{
                        ToolbarItem(placement: .keyboard){
                            HStack{
                                Spacer()
                                Button("Close"){
                                    self.focus = false
                     }}}}
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }
            

            if onAlertForAddCategoly {
                NavigationView{
                    ZStack() {
                            Rectangle()
                            .foregroundColor(.white)
                            VStack {
                                TextField("新しいカテゴリー名",text: $newCategolyName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .focused(self.$focus)
                                    .toolbar{
                                        ToolbarItem(placement: .keyboard){
                                            HStack{
                                                Spacer()
                                                Button("Close"){
                                                    self.focus = false
//                                                    AddCategolyButtonAvariable()
                                     }}}}
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        materialCategolies.AddCategoly(_categolyName: newCategolyName, _indexNum: materialCategolies.list.count)
                                        self.onAlertForAddCategoly.toggle()
                                        newCategolyName = ""
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddCategolyButtonAvariable)
//                                    .disabled(!self.isEnableCategolyAddButton)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForAddCategoly.toggle()
                                        newCategolyName = ""
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddCategolyButtonAvariable()
//                        }

                    }
                .frame(width: 300, height: 180,alignment: .center)
                .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }
        }
    }
    
    
    var AddCategolyButtonAvariable: Bool{
         newCategolyName != ""
    }
    
    
    var AddMaterialButtonAvariable: Bool{
        newMaterialName != "" && newMaterialCost != ""
    }
    

}

//struct MaterialManegementView_Previews: PreviewProvider {
//    static var previews: some View {
//        MaterialManegementView()
//    }
//}
