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



struct OrderAdditionView: View {
    
    @ObservedObject var productCategolies : ProductCategolies
    @ObservedObject var souldProductAll : SouldProductAll
    
    @State private var selectionDate = Date()
    @State private var selectedProductCategoly: aProductCategoly = aProductCategoly(_name: "none", _index: 0)
    @State private var selectedProduct: aProduct = aProduct(_name: "none", _price: 0, _cost: 0, _index: 0)
    @State private var selectedShipmentCost = ""
    @State private var selectedWrappingCost = ""
    
    @State var isEnableAddButton : Bool = false
    @State var previousSelectedProduct : String = ""

    @FocusState var focus:Bool

    @State private var isShowingView: Bool = false
        
    
//    var dateFormat: DateFormatter {
//      let format = DateFormatter()
//        format.dateStyle = .full // .full | .long | .medium | .short | .none
//        format.dateFormat = "yyyy-MM-dd"
//      return format
//    }
    
    
    
    var body: some View {

        
        VStack{
            List {
                Section(header:Text("日付").font(.subheadline)){
                    HStack{
                        Text("購入された日付")
                        Spacer()
                        DatePicker("タイトル",selection: $selectionDate,displayedComponents: [.date])
                        .labelsHidden()
                    }
//                  Spacer()
//                  DatePicker("タイトル",selection: $selectionDate,displayedComponents: [.date])
//                  .labelsHidden()
//                  .datePickerStyle(WheelDatePickerStyle())
//                  .frame(width: 198, height: 100)
//                  Spacer()

                }

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
                
                Section(header:Text("雑費").font(.subheadline)){
                    HStack{
                        Text("送料")
                        
                        Spacer()
                        TextField("",text: $selectedShipmentCost)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.roundedBorder)
                            .focused(self.$focus)
                            .toolbar{
                                ToolbarItem(placement: .keyboard){
                                    HStack{
                                        Spacer()
                                        Button("Close"){
                                            self.focus = false
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
                            .focused(self.$focus)

                        Text("円")
                    }
                }

                
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

    func GetGuideText(isFromCategoly : Bool) -> String{
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
    
    func AddButtonAvariable(){
        isEnableAddButton = InputFeildIsFilled() ? true : false
    }
    
    func InputFeildIsFilled() -> Bool{
        return selectedShipmentCost != "" && selectedWrappingCost != "" &&
        selectedProductCategoly.name != "none" && selectedProduct.name != "none"
    }
}



//struct OrderManegementView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderAdditionView()
//    }
//}
