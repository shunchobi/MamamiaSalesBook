//
//  MaterialManegementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


///
///
//材料を登録、削除する画面を表示するView
///
///
struct MaterialManegementView: View {
    
    @ObservedObject var materialCategolies : MaterialCategolies
    
    //新しく登録する材料の情報
    @State var newCategolyName: String = ""
    @State var newMaterialName: String = ""
    @State var newMaterialCost: String = ""
    @State var actionedCategolyButton: String = ""
    
    //カテゴリー、材料を登録する際に必要な情報がすべて入力されているかどうかを返すBool値
    @State var isEnableCategolyAddButton: Bool = false
    @State var isEnableMaterialAddButton: Bool = false

    //削除される材料のカテゴリーを保持する配列データが代入される
    @State var willDeleteCategoly: aMaterialCategoly? = nil
    
    //キーボード上に表示されているキャンセルボタンで、ユーザーからのアクションを受け取る
    //キャンセルボタンが押されればFalseになり、キーボードが閉じる
    @FocusState var cancelButtonOnKeyboard: Bool

    //各アラートの表示非表示をBoolで管理
    @State var onAlertForAddCategoly: Bool = false
    @State var onAlertForAddMaterial: Bool = false
    @State var onAlertForDeleteCategoly: Bool = false

    
    var body: some View {
        
        ZStack {
          NavigationView {
            List {
                //登録されている材料のカテゴリーを表示
                ForEach (materialCategolies.list){categoly in
                    Section(header : HStack{
                        Text("\(categoly.name)")
                        //カテゴリーを削除するButton
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
                            actionedCategolyButton = categoly.name
                            self.onAlertForAddMaterial.toggle()
                        })
                            .foregroundColor(.blue);
                        Spacer()
                    })
                    {
                        //登録されている材料を表示
                        ForEach(categoly.materials) {material in
                            HStack{
                                Text(material.name)
                                Spacer()
                                Text("\(material.cost)円")
                            }
                        }
                        //スライドで削除
                        .onDelete { indexSet in
                            materialCategolies.list[categoly.index].materials.remove(atOffsets: indexSet)
                            materialCategolies.SaveMaterialData()
                        }
                }
              }
            }
            .navigationTitle("材料管理")
            .listStyle(SidebarListStyle())
              //カテゴリーを追加するButton
            .toolbar {Button(action:{ self.onAlertForAddCategoly.toggle() }){ Text("カテゴリー追加＋") }}
          }
          .navigationBarTitleDisplayMode(.inline)
          .navigationBarBackButtonHidden(false)
            
            
            //登録されているカテゴリーを削除するためのアラートを表示
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
                                    //ユーザーがOKボタンを押すとカテゴリーが削除される
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
                                    //ユーザーがキャンセルを選択で、アラートを閉じる
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

                    }
                .frame(width: 300, height: 180,alignment: .center)
                .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }


            //新しい材料を登録するためのアラートを表示
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
                                    //OKボタンを押すと、キーボードから入力された材料情報を登録し、新しくaMaterialを生成し配列データへ追加する
                                    Button("OK") {
                                        for i in 0..<materialCategolies.list.count{
                                            if(materialCategolies.list[i].name == self.actionedCategolyButton){
                                                let material = aMaterial(_name:newMaterialName, _cost:Int(newMaterialCost) ?? 0)
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
                                    //ユーザーがキャンセルを選択で、アラートを閉じる
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
                    }
                    .frame(width: 300, height: 200,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                    .focused(self.$cancelButtonOnKeyboard)
                    .toolbar{
                        ToolbarItem(placement: .keyboard){
                            HStack{
                                Spacer()
                                Button("Close"){
                                    self.cancelButtonOnKeyboard = false
                     }}}}
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }
            

            //新しい材料のカテゴリーを追加するためのアラート
            if onAlertForAddCategoly {
                NavigationView{
                    ZStack() {
                            Rectangle()
                            .foregroundColor(.white)
                            VStack {
                                TextField("新しいカテゴリー名",text: $newCategolyName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .focused(self.$cancelButtonOnKeyboard)
                                    .toolbar{
                                        ToolbarItem(placement: .keyboard){
                                            HStack{
                                                Spacer()
                                                Button("Close"){
                                                    self.cancelButtonOnKeyboard = false
                                     }}}}
                                Spacer()
                                HStack {
                                    Spacer()
                                    //ユーザーがOKを選択で、キーボードから入力されたカテゴリー名を登録し、新しいカテゴリーを生成し配列データへ追加する
                                    Button("OK") {
                                        materialCategolies.AddCategoly(_categolyName: newCategolyName, _indexNum: materialCategolies.list.count)
                                        self.onAlertForAddCategoly.toggle()
                                        newCategolyName = ""
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddCategolyButtonAvariable)
                                    Spacer()
                                    //ユーザーがキャンセルを選択で、アラートを閉じる
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
                    }
                .frame(width: 300, height: 180,alignment: .center)
                .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

            }
        }
    }
    
    
    //新しいカテゴリーを生成する際に、カテゴリー名がキーボードから入力されているかどうかをBool値で返す
    var AddCategolyButtonAvariable: Bool{
         newCategolyName != ""
    }
    
    //新しい材料を生成する際に、材料の各情報がキーボードから入力されているかどうかをBool値で返す
    var AddMaterialButtonAvariable: Bool{
        newMaterialName != "" && newMaterialCost != ""
    }
    

}

