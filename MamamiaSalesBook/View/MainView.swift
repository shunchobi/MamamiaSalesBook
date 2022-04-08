//
//  ContentView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


///
///
//アプリ起動時の最初の画面
///
///
struct MainView: View {
    
    //ここで各データをインスタンス化し、他Viewから参照している
    @ObservedObject public var souldProductAll: SouldProductAll = SouldProductAll()
    @ObservedObject public var productCategolies: ProductCategolies = ProductCategolies()
    @ObservedObject public var materialCategolies: MaterialCategolies = MaterialCategolies()
    
    //今現在の年月を保持
    let nowYear: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
    let nowMonth: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
    

    var body: some View {
        
        let fontsize : Double = 30
        
        NavigationView{
            VStack(spacing: 59){
                
                //タイトル
                Text("Mamamia 売上管理")
                    .font(.largeTitle)
                
                //売り上げ結果を表示
                NavigationLink(destination: SalesManagementView(
                    souldProductAll: souldProductAll,
                    displaySales: souldProductAll.GetTotalSalesMonthly(year: nowYear, month: nowMonth),
                    displayCost: souldProductAll.GetTotalCostMonthly(year: nowYear, month: nowMonth),
                    dispayProfit:souldProductAll.GetProfitForIniti())){
                    Text("売上")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
                
                //注文情報を管理する画面を表示
                NavigationLink(destination: OrderAdditionView(productCategolies: productCategolies, souldProductAll: souldProductAll)){
                    Text("注文管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
                
                //商品情報を管理する画面を表示
                NavigationLink(destination: ProductManegementView(productCategolies: productCategolies, materialCategolies: materialCategolies)){
                    Text("商品管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
                
                //材料情報を管理する画面を表示
                NavigationLink(destination: MaterialManegementView(materialCategolies: materialCategolies)){
                    Text("材料管理")
                        .font(.system(size: fontsize, weight: .bold, design: .default))
                }
                .padding(.bottom, 150)
            }
        }
    }
}
