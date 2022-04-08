//
//  ProductManegementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI

///
///
//新しい商品を追加する際、その商品の材料を登録するときに
//MaterialContentViewから各値が変更される
///
///
class CostInfo{
    static var cost : Int = 0
    static var myMaterials : [aMaterial] = []
}



///
///
//商品情報を表示、登録、削除などの管理を行うView
///
///
struct ProductManegementView: View {
    
    @ObservedObject var productCategolies: ProductCategolies
    @ObservedObject var materialCategolies: MaterialCategolies
    
    //各アラートの表示非表示をBoolで管理
    @State var onAlertForAddCategoly: Bool = false
    @State var onAlertForAddProduct: Bool = false
    @State var onAlertForDeleteCategoly: Bool = false
    
    //新しい商品を追加するときに必要な商品情報
    @State var newCategolyName: String = ""
    @State var newProductName: String = ""
    @State var newProductPrice: String = ""
    @State var newProductCost: String = "0"
    @State var actionedCategolyButton: String = ""
    
    //キーボード上に表示されているキャンセルボタンで、ユーザーからのアクションを受け取る
    //キャンセルボタンが押されればFalseになり、キーボードが閉じる
    @FocusState var cancelButtonOnKeyboard: Bool
    
    //既に追加されている商品で登録されている材料が現在表示されているかどうかを管理
    @State var isShowingMyMaterialsView: Bool = false
    
    //商品カテゴリーを削除する際に、一度このwillDeleteCategolyに対象のカテゴリーを入れる
    @State var willDeleteCategoly: aProductCategoly? = nil
    
    
    var body: some View {
        ZStack {
            
          NavigationView {
            List {
                //登録されているカテゴリーを表示
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
                            actionedCategolyButton = categoly.name
                            self.onAlertForAddProduct.toggle()
                        })
                            .foregroundColor(.blue);
                        Spacer()
                    })
                    {
                        //登録されている商品をカテゴリーごとに表示
                        ForEach(categoly.products) {product in
                            //MyMaterialsView(自身の登録されている材料を表示するView)を表示するためのButton
                            Button(action: {
                                isShowingMyMaterialsView.toggle()
                            }){
                                HStack{
                                    Text(product.name)
                                    Spacer()
                                    Text("\(product.cost)円 / \(product.price)円 >")
                                }
                            }
                            .sheet(isPresented: $isShowingMyMaterialsView) {
                                MyMaterialsView(product: product)
                            }
                        }
                        //スライドで削除可能
                        .onDelete { indexSet in
                            productCategolies.list[categoly.index].products.remove(atOffsets: indexSet)
                            productCategolies.SaveProductData()
                        }
                }
              }
            }
            .navigationTitle("商品管理")
            .listStyle(SidebarListStyle())
              //カテゴリーを追加するためのButtonをツールバーに追加
            .toolbar {Button(action:{ self.onAlertForAddCategoly.toggle() }){ Text("カテゴリー追加＋") }}
          }
          .navigationBarTitleDisplayMode(.inline)
          .navigationBarBackButtonHidden(false)
            
            
            //カテゴリーを削除する際に表示されるアラート
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
                                    //ユーザーがOKを選択で、productCategolies.listで保持されているカテゴリーを削除
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
                                    .frame(width: 101, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    Spacer()
                                    //ユーザーがキャンセルを選択で、アラートを閉じる
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
                    }
                    .frame(width: 300, height: 180,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }

            
            
    
            //商品を追加する際に表示されるアラート
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
                                    //ユーザーがOKを選択で、キーボードから入力された商品情報を登録し、新しくaProductを生成し配列データへ追加する
                                    Button("OK") {
                                        for i in 0..<productCategolies.list.count{
                                            if(productCategolies.list[i].name == self.actionedCategolyButton){
                                                var newProduct = aProduct(_name:newProductName, _price:Int(newProductPrice) ?? 0, _cost:CostInfo.cost, _index: productCategolies.list[i].products.count)
                                                
                                                newProduct.myMaterials = CostInfo.myMaterials
                                                productCategolies.AddProduct(index: i, product: newProduct)
                                            }
                                        }
                                        self.onAlertForAddProduct.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newProductName = ""
                                        newProductPrice = ""
                                        newProductCost = "0"
                                        CostInfo.cost = 0
                                        CostInfo.myMaterials = []
                                    }
                                    .frame(width: 100, height: 15)
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!AddProductButtonAvariable)
                                    Spacer()
                                    //ユーザーがキャンセルを選択で、アラートを閉じる
                                    Button("キャンセル") {
                                        self.onAlertForAddProduct.toggle()
                                        self.actionedCategolyButton = ""
                                        newCategolyName = ""
                                        newProductName = ""
                                        newProductPrice = ""
                                        newProductCost = "0"
                                        CostInfo.cost = 0
                                        CostInfo.myMaterials = []
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
                            .focused(self.$cancelButtonOnKeyboard)
                            .toolbar{
                                ToolbarItem(placement: .keyboard){
                                    HStack{
                                        Spacer()
                                        Button("Close"){
                                            self.cancelButtonOnKeyboard = false
                             }}}}
                    }
                    .frame(width: 300, height: 220,alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
            
    
            //カテゴリーを追加する際に表示されるアラート
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
    
    //新しい商品を生成する際に、商品の各情報がキーボードから入力されているかどうかをBool値で返す
    var AddProductButtonAvariable: Bool{
        newProductName != "" && newProductPrice != "" && CostInfo.cost != 0
    }
    
    //新しい商品を生成する際に、選択した材料費をこのメソッドで商品情報のnewProductCostへ値を代入
    func ChageNewProductCostNum(){
        newProductCost = String(CostInfo.cost)
    }

}

