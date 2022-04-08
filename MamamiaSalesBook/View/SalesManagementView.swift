//
//  SalesManagementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI


///
///
//売り上げ結果を表示するView
///
///
struct SalesManagementView: View {
    
    @ObservedObject var souldProductAll : SouldProductAll
    
    //日付を指定するためのカレンダー
    @State private var selectedDate = Date()
    @State public var selectedYear: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
    @State public var selectedMonth: Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
    
    //選択可能な年月のInt値
    private let yearRange = [Int](2022...2053)
    private let monthRange = [Int](1...12)

    //表示する売り上げ、原価、利益の値
    @State var displaySales: Int
    @State var displayCost: Int
    @State var dispayProfit: Int

    //各アラートの表示非表示をBoolで管理
    @State private var onAlertForYear: Bool = false
    @State private var onAlertForMonth: Bool = false
    
    //年月の値をNumberFormatterで変換するためのもの
    private let numberFormatter = NumberFormatter()


    var body: some View {
        ZStack{
            VStack{
                //タイトル
                Text("売上結果")
                    .font(.largeTitle)
                    .kerning(6)
                
                //表示したい売り上げ結果の年月を指定
                Spacer().frame(height: 15)
                HStack{
                    Spacer()
                    Button(action:{ self.onAlertForYear.toggle()}){
                        Text("\(numberFormatter.string(from: NSNumber(integerLiteral: self.selectedYear)) ?? "\(self.selectedYear)")年")
                            .font(.system(size:30))
                    }
                    Text(".")
                        .font(.system(size:25))
                    Button(action:{ self.onAlertForMonth.toggle()}){
                        Text("\(numberFormatter.string(from: NSNumber(integerLiteral: self.selectedMonth)) ?? "\(self.selectedMonth)")月")
                        .font(.system(size:30))
                    }
                    Spacer()
                }

                //売り上げ、原価、利益を表示
                Spacer()
                VStack(spacing: 20){
                    Text("・売上合計 = \(String(self.displaySales))円")
                        .font(.system(size: 30))
                        .kerning(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("・原価合計 = \(String(self.displayCost))円")
                        .font(.system(size: 30))
                        .kerning(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("・利益合計 = \(String(self.dispayProfit))円")
                        .font(.system(size: 30))
                        .kerning(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                //注文された商品を表示
                Spacer()
                List{
                    Section (header: HStack{
                        Text("購入された商品") .font(.title3)
                        Spacer()
                        Text("コスト/売値")
                    }){
                        ForEach(GetArray()){ soldProduct in
                            HStack{
                                Text(String(soldProduct.month)+"/"+String(soldProduct.day))
                                Text(soldProduct.name)
                                Spacer()
                                Text(String(soldProduct.GetTotalCost())+"円/")
                                Text(String(soldProduct.price)+"円")
                            }
                        }
                    }
                }
                .frame(height: 220)
            }
            .navigationBarTitleDisplayMode(.inline)        
        
            
            //年を指定するためのアラート
            if onAlertForYear{
                NavigationView{
                    VStack{
                        Picker("yearRange", selection: $selectedYear){
                            ForEach(yearRange, id: \.self){year in
                                Text(String(year)+"年")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        
                        Button("閉じる", action:{
                            displaySales = souldProductAll.GetTotalSalesMonthly(year: selectedYear, month: selectedMonth)
                            displayCost = Int(souldProductAll.GetTotalCostMonthly(year: selectedYear, month: selectedMonth))
                            dispayProfit = displaySales - displayCost
                            
                            onAlertForYear.toggle()
                        })
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        
            
            //月を指定するためのアラート
            if onAlertForMonth{
                NavigationView{
                    VStack{

                    Picker("yearRange", selection: $selectedMonth){
                        ForEach(monthRange, id: \.self){month in
                            Text(String(month)+"月")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                    
                    Button("閉じる", action:{
                        displaySales = souldProductAll.GetTotalSalesMonthly(year: selectedYear, month: selectedMonth)
                        displayCost = souldProductAll.GetTotalCostMonthly(year: selectedYear, month: selectedMonth)
                        dispayProfit = displaySales - displayCost

                        onAlertForMonth.toggle()})
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            
        }
    }
    
    
    //指定された年月の注文商品のデータを保持する配列を返す
    func GetArray() ->[aSoldProduct]{
        return souldProductAll.GetMonthlyList(year: selectedYear, month: selectedMonth)
    }

}

