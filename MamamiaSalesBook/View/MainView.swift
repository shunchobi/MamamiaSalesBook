//
//  ContentView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI

struct MainView: View {
    @ObservedObject public var souldProductAll : SouldProductAll = SouldProductAll()
    @ObservedObject public var productCategolies : ProductCategolies = ProductCategolies()
    @ObservedObject public var materialCategolies : MaterialCategolies = MaterialCategolies()
    

    init(){
//        _ = OrderAdditionView(productCategolies: productCategolies, souldProductAll: souldProductAll)
    }
    
    var body: some View {
        
        let fontsize : Double = 30
        
        NavigationView{
            VStack(spacing: 60){
                Text("Mamamia 売上管理")
//                    .padding(.bottom, 50)
                    .font(.largeTitle)
                
                NavigationLink(destination: SalesManagementView(souldProductAll: souldProductAll, displaySales: souldProductAll.GetTotalPriceMonthlyForIniti(), displayCost: souldProductAll.GetTotalCostMonthlyForIniti(), dispayProfit:souldProductAll.GetProfitForIniti())){
                    Text("売上")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
//                        .padding(20)
//                        .overlay( RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.red, lineWidth: 4)
//                        )
                }
//                .padding(.bottom, 30)
                NavigationLink(destination: OrderAdditionView(productCategolies: productCategolies, souldProductAll: souldProductAll)){
                    Text("注文管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
//                .padding(.bottom, 30)
                NavigationLink(destination: ProductManegementView(productCategolies: productCategolies, materialCategolies: materialCategolies)){
                    Text("商品管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
//                .padding(.bottom, 30)
                NavigationLink(destination: MaterialManegementView(materialCategolies: materialCategolies)){
                    Text("材料管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
                .padding(.bottom, 150)
            }
//            .navigationBarTitle(Text("Mamamia売上管理アプリ"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
