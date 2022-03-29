//
//  ProductManegementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


class Cost{
    static var num : Int = 0
    static var myMaterials : [aMaterial] = []
    
}


struct ProductManegementView: View {
    
    @ObservedObject var productCategolies : ProductCategolies
    @ObservedObject var materialCategolies : MaterialCategolies

    
    @State var onAlertForAddCategoly = false
    @State var onAlertForAddProduct = false
    @State var onAlertForDeleteCategoly = false
    @State var newCategolyName = ""
    @State var newProductName = ""
    @State var newProductPrice = ""
    @State var newProductCost = "0"
    @State var actionedCategolyButton = ""
    @State var Index = 0
    
    @FocusState var focus:Bool
    @State var isEnableCategolyAddButton : Bool = false
    @State var isEnableProductAddButton : Bool = false
    @State var isShowingView : Bool = false
    
    @State var willDeleteCategoly: aProductCategoly? = nil
    
    var body: some View {
        ZStack {
            
          NavigationView {
            List {
                ForEach (productCategolies.list){categoly in
                    Section(header : HStack{
                        Text("\(categoly.name)")
                        Button("✖️", action:{
                            willDeleteCategoly = categoly
                            print(categoly.index)
                            onAlertForDeleteCategoly = true
                        })
                            .foregroundColor(.red);
                        Spacer()
                        Text("原価 / 売値").font(.subheadline)
                    },footer : HStack{
                        Spacer();
                        Button("Add", action:{
//                            categolyIndex = categoly.index
                            actionedCategolyButton = categoly.name
                            self.onAlertForAddProduct.toggle()
                        })
                            .foregroundColor(.blue);
                        Spacer()
                    })
                    {
                        ForEach(categoly.products) {product in
                            Button(action: {
                                isShowingView.toggle()
                            }){
                                HStack{
                                    Text(product.name)
                                    Spacer()
                                    Text("\(product.cost)円 / \(product.price)円 >")
                                }
                            }
                            .sheet(isPresented: $isShowingView) {
                                MyMaterialsView(product: product)
                            }
                        }
                        .onDelete { indexSet in
                            productCategolies.list[categoly.index].products.remove(atOffsets: indexSet)
                            productCategolies.SaveProductData()
                        }
                }
              }
                //Delete Categoly
//                .onDelete { indexSet in
//                    productCategolies.list.remove(atOffsets: indexSet)
//                    for i in 0..<productCategolies.list.count{
//                        productCategolies.list[i].ChangeIndex(_index: productCategolies.list.count - 1)
//                        productCategolies.SaveProductData()
//                    }
//                }
            }
            .navigationTitle("商品管理")
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
                                Spacer()
                                Text("「\(willDeleteCategoly!.name)」")
                                Text("本当にカテゴリーを消しますか？")
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        let deleteName: String = willDeleteCategoly!.name
                                        for i in 0..<productCategolies.list.count{
                                            let targetName = productCategolies.list[i].name
                                            if targetName == deleteName{
                                                productCategolies.list.remove(at: i)
                                                break
                                            }
                                        }
                                        for i in 0..<productCategolies.list.count{
                                            productCategolies.list[i].ChangeIndex(_index: productCategolies.list.count - 1)
                                        }
                                        print(productCategolies.list.count)
                                        productCategolies.SaveProductData()
                                        self.onAlertForDeleteCategoly.toggle()
                                    }
                                    .frame(width: 100, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForDeleteCategoly.toggle()
                                    }
                                    .frame(width: 150, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer()
                            }.padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddCategolyButtonAvariable()
//                            }
                    }
                    .frame(width: 300, height: 180,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }

            
            
    

            if onAlertForAddProduct {
                NavigationView{
                    ZStack() {
                            Rectangle()
                            .foregroundColor(.white)
                            VStack {
                                Spacer().frame(height: 15)
                                TextField("新しい商品名",text: $newProductName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding().frame(height: 30)
                                Spacer().frame(height: 20)
                                TextField("販売価格",text: $newProductPrice)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding().frame(height: 30)
                                    .keyboardType(.numberPad)
                                Spacer().frame(height: 20)
                                NavigationLink("使用材料を選択 原価: "+newProductCost+"円", destination: MaterialContentView(materialCategolies: materialCategolies).onDisappear(perform: {
                                    ChageNewProductCostNum()
                                }))
                                Spacer().frame(height: 30)
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        for i in 0..<productCategolies.list.count{
                                            if(productCategolies.list[i].name == self.actionedCategolyButton){
                                                var newProduct = aProduct(_name:newProductName, _price:Int(newProductPrice) ?? 0, _cost:Cost.num, _index: productCategolies.list[i].products.count)
                                                
                                                ///ここでしっかり渡せられているか？
                                                newProduct.myMaterials = Cost.myMaterials
                                                ///
                                                
//                                                productCategolies.list[i].products.append(newProduct)
                                                productCategolies.AddProduct(index: i, product: newProduct)
                                            }
                                        }
                                        self.onAlertForAddProduct.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newProductName = ""
                                        newProductPrice = ""
                                        newProductCost = "0"
                                        Cost.num = 0
                                        Cost.myMaterials = []
                                    }
                                    .frame(width: 100, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddProductButtonAvariable)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForAddProduct.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newProductName = ""
                                        newProductPrice = ""
                                        newProductCost = "0"
                                        Cost.num = 0
                                        Cost.myMaterials = []
                                    }
                                    .frame(width: 150, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer().frame(height: 20)
                            }
                            .padding()
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                            }
                            .focused(self.$focus)
                            .toolbar{
                                ToolbarItem(placement: .keyboard){
                                    HStack{
                                        Spacer()
                                        Button("Close"){
                                            self.focus = false
                             }}}}
                    }
                    .frame(width: 300, height: 220,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
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
                                Spacer()
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
                                     }}}}
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button("OK") {
                                        productCategolies.AddCategoly(_categolyName: newCategolyName, _indexNum: productCategolies.list.count)
                                        self.onAlertForAddCategoly.toggle()
                                        newCategolyName = ""
                                    }
                                    .frame(width: 100, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddCategolyButtonAvariable)
                                    Spacer()
                                    Button("キャンセル") {
                                        self.onAlertForAddCategoly.toggle()
                                        newCategolyName = ""
                                    }
                                    .frame(width: 150, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                    Spacer()
                                }
                                Spacer()
                            }.padding()
//                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
//                                AddCategolyButtonAvariable()
//                            }
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
    
    
    var AddProductButtonAvariable:Bool{
        newProductName != "" && newProductPrice != "" && Cost.num != 0
    }
    
    func ChageNewProductCostNum(){
        newProductCost = String(Cost.num)
    }

}




//
//struct ProductManegementView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductManegementView(viewModel: <#ProductCategolies#>)
//    }
//}
