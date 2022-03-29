//
//  SalesManagementView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/14.
//

import SwiftUI

struct SalesManagementView: View {
    
    @ObservedObject var souldProductAll : SouldProductAll
    
    @State private var selectedDate = Date()
    @State public var selectedYear : Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).year!
    @State public var selectedMonth : Int = Calendar.current.dateComponents([.year, .month, .day], from: Date()).month!
    private let yearRange = [Int](2022...2053)
    private let monthRange = [Int](1...12)

    //画面開いと時に、今の年月が表示されているが、売上結果の値が反映されてない
    @State var displaySales : Int //souldProductAll.GetTotalPriceMonthly(year: selectedYear, month: selectedMonth)
    @State var displayCost : Int
    @State var dispayProfit : Int

    @State private var onAlertForYear : Bool = false
    @State private var onAlertForMonth : Bool = false
    
    private let f = NumberFormatter()
    

//    init(){
//        let data = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
//        _selectedYear = State(initialValue: data.year!)
//        _selectedMonth = State(initialValue: data.month!)
//        f.numberStyle = .none
//
//        _displaySales = State(initialValue:souldProductAll.GetTotalPriceMonthly(year: selectedYear, month: selectedMonth))
//        _displayCost = State(initialValue:Int(souldProductAll.GetTotalCostMonthly(year: selectedYear, month: selectedMonth)))
//        _dispayProfit = State(initialValue:displaySales - displayCost)
//
//        _array = State(initialValue: self.souldProductAll.GetMonthlyList(year: self.selectedYear, month: self.selectedMonth))
//    }



    var body: some View {
        ZStack{
            VStack{
                Text("売上結果")
                    .font(.largeTitle)
                    .kerning(6)
                
                
                Spacer().frame(height: 15)
                HStack{
                    Spacer()
                    Button(action:{ self.onAlertForYear.toggle()}){
                        Text("\(f.string(from: NSNumber(integerLiteral: self.selectedYear)) ?? "\(self.selectedYear)")年")
                            .font(.system(size:30))
                    }
                    Text(".")
                        .font(.system(size:25))
                    Button(action:{ self.onAlertForMonth.toggle()}){
                        Text("\(f.string(from: NSNumber(integerLiteral: self.selectedMonth)) ?? "\(self.selectedMonth)")月")
                        .font(.system(size:30))
                    }
                    Spacer()
                }

                
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
            //end -> VStack
        
        
            
            
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
                                displaySales = souldProductAll.GetTotalPriceMonthly(year: selectedYear, month: selectedMonth)
                                displayCost = Int(souldProductAll.GetTotalCostMonthly(year: selectedYear, month: selectedMonth))
                                dispayProfit = displaySales - displayCost
                                
                                onAlertForYear.toggle()
                            })
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
            
            
            
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
                            displaySales = souldProductAll.GetTotalPriceMonthly(year: selectedYear, month: selectedMonth)
                            displayCost = souldProductAll.GetTotalCostMonthly(year: selectedYear, month: selectedMonth)
                            dispayProfit = displaySales - displayCost

                            onAlertForMonth.toggle()})
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
                
            }//end -> ZStack
    } //end -> var body: some View
    
    func rowRemove(offsets: IndexSet) {
        self.souldProductAll.list.remove(atOffsets: offsets)
        self.souldProductAll.SaveSoldProductData()
    }
    
    
    func GetArray() ->[aSoldProduct]{
        return souldProductAll.GetMonthlyList(year: selectedYear, month: selectedMonth)
    }

}//end -> struct SalesManagementView: View






//struct SalesManagementView_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesManagementView()
//    }
//}
