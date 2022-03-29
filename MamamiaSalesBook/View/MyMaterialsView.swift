//
//  MyMaterialsView.swift
//  MamamiaSalesBook
//
//  Created by Shun on 2022/03/24.
//

import SwiftUI

struct MyMaterialsView: View {
    
    let product : aProduct
    
    
    var body: some View {
        List{
            Section (header: HStack{
                Spacer()
                VStack{
                    Text("「\(product.name)」")
                        .font(.system(size:25))
                    Spacer().frame(height: 10)
                    Text("使用されている材料リスト")
                        .font(.system(size:18))
                }
                Spacer()
            }){
                ForEach(product.myMaterials){material in
                    HStack{
                        Text(material.name)
                        Spacer()
                        Text("\(material.cost)円")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
    }

}

//struct MyMaterialsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyMaterialsView()
//    }
//}
