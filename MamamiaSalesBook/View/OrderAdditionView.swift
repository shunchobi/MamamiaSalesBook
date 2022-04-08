//
//  OrderManegementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


enum TextGuide: String {
    case noCategoly = "選択できるカテゴリーがありません"
    case noProduct = "選択できる商品がありません"
    case chooseCategoly = "カテゴリーを選択"
    case chooseProduct = "商品を選択"
}


///
///
//注文情報の登録を行うView
///
///
struct OrderAdditionView: View {
    
    @ObservedObject var productCategolies : ProductCategolies
    @ObservedObject var souldProductAll : SouldProductAll
    
    //日付を指定するためのカレンダー
    @State private var selectionDate = Date()
    
    //登録する注文された商品の情報
    @State private var selectedProductCategoly: aProductCategoly = aProductCategoly(_name: "none", _index: 0)
    @State private var selectedProduct: aProduct = aProduct(_name: "none", _price: 0, _cost: 0, _index: 0)
    @State private var selectedShipmentCost: String = ""
    @State private var selectedWrappingCost: String = ""
    
    //登録する商品の情報がすべて入力されているかどうかを返すBool値
    @State var isEnableAddButton: Bool = false
    
    //登録する際に選んだ商品の名前を保持
    @State var previousSelectedProduct: String = ""

    //キーボード上に表示されているキャンセルボタンで、ユーザーからのアクションを受け取る
    //キャンセルボタンが押されればFalseになり、キーボードが閉じる
    @FocusState var cancelButtonOnKeyboard: Bool

    //OrderEditingViewを表示中かどうかを返すBool値
    @State private var isShowingView: Bool = false
    
    
    var body: some View {
        VStack{
            //登録する注文の日付を入力
            List {
                Section(header:Text("日付").font(.subheadline)){
                    HStack{
                        Text("購入された日付")
                        Spacer()
                        DatePicker("タイトル",selection: $selectionDate,displayedComponents: [.date])
                        .labelsHidden()
                    }
                }

                //登録する商品を選択
                Section(header:Text("商品選択").font(.subheadline)){
                    Picker(GetGuideText(isFromCategoly : true), selection: $selectedProductCategoly) {
                        ForEach(productCategolies.list, id: \.self) { category in
                            Text(category.name)
                                .tag(category)
                        }
                    }.onChange(of: selectedProductCategoly) { _ in
                        AddButtonAvariable()
                        if previousSelectedProduct == selectedProduct.name {
                            self.isEnableAddButton = false
                        }
                     }

                    Picker(GetGuideText(isFromCategoly : false), selection: $selectedProduct) {
                        ForEach(selectedProductCategoly.products, id: \.self) {product in
                            Text(product.name)
                                .tag(product)
                        }
                    }.onChange(of: selectedProduct) { _ in
                        previousSelectedProduct = selectedProduct.name
                        AddButtonAvariable()
                    }
                }
                
                //登録する送料と梱包日を入力
                Section(header:Text("雑費").font(.subheadline)){
                    HStack{
                        Text("送料")
                        
                        Spacer()
                        TextField("",text: $selectedShipmentCost)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.roundedBorder)
                            .focused(self.$cancelButtonOnKeyboard)
                            .toolbar{
                                ToolbarItem(placement: .keyboard){
                                    HStack{
                                        Spacer()
                                        Button("Close"){
                                            self.cancelButtonOnKeyboard = false
                                            AddButtonAvariable()
                             }}}}

                        Text("円")
                    }
                    HStack{
                        Text("梱包費")
                        TextField("",text: $selectedWrappingCost)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.roundedBorder)
                            .focused(self.$cancelButtonOnKeyboard)

                        Text("円")
                    }
                }

                
                //入力した注文情報もとにaSoldProductを生成してデータ配列へ追加
                Section{
                    HStack{
                        Spacer()
                        Button(action: {
                            let data = Calendar.current.dateComponents([.year, .month, .day], from: selectionDate)
                            let year =  data.year!
                            let month =  data.month!
                            let day =  data.day!
                            let name : String = selectedProduct.name
                            let shipment : Int = Int(selectedShipmentCost)!
                            let wrappingCost : Int = Int(selectedWrappingCost)!
                            let materialCost : Int = selectedProduct.cost
                            let price : Int = selectedProduct.price
                            
//                            var existSoldProduct : Bool = false

                            let aSoldProduct = aSoldProduct(_name: name, _materialCost: materialCost, _shipment: shipment, _wrappingCost: wrappingCost, _price: price, _year: year, _month: month, _day: day)
                            
                            souldProductAll.AddSouldProductMonthly(_aSoldProduct: aSoldProduct)
                            
                            //入力されているデータを空にする
                            selectedShipmentCost = ""
                            selectedWrappingCost = ""
                            AddButtonAvariable()
                        }){
                            Text("売上管理へ追加")
                                .frame(width: 198, height: 35)
                                .font(.system(size: 20.0))
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!self.isEnableAddButton)
                        
                        
                        Spacer()
                }
                    .listRowBackground(Color.clear)
                    
                }

                //登録されている注文商品を表示、削除するためのViewを表示
                Section{
                    HStack{
                        Spacer()
                        Button(action: {
                            isShowingView.toggle()
                        }){
                            Text("追加した商品を編集")
                                .frame(width: 198, height: 35)
                                .font(.system(size: 20.0))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .sheet(isPresented: $isShowingView) {
                            OrderEditingView(souldProductAll: souldProductAll)
                        }
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
    }

    //TextGuide enumから文字列を取得
    func GetGuideText(isFromCategoly: Bool) -> String{
        var result = ""
        if productCategolies.list.count > 0{
            if isFromCategoly {result = TextGuide.chooseCategoly.rawValue}
            if !isFromCategoly {result = TextGuide.chooseProduct.rawValue}
        }
        else {
            if isFromCategoly {result = TextGuide.noCategoly.rawValue}
            if !isFromCategoly {result = TextGuide.noProduct.rawValue}
        }
        return result
    }
    
    //注文商品の情報が全て入力されているかどうかのBool値をisEnableAddButtonへ代入
    func AddButtonAvariable(){
        isEnableAddButton = InputFeildIsFilled() ? true : false
    }
    
    //注文商品の情報が全て入力されているかどうかのBool値を返す
    func InputFeildIsFilled() -> Bool{
        return selectedShipmentCost != "" && selectedWrappingCost != "" &&
        selectedProductCategoly.name != "none" && selectedProduct.name != "none"
    }
}

