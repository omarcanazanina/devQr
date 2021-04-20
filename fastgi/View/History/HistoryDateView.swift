//
//  HistoryDateView.swift
//  fastgi wallet
//
//  Created by Hegaro on 24/03/2021.
//

import SwiftUI

struct HistoryDateView: View {
    @State private var fechaInicial = Date()
    @State private var fechaFinal = Date()
    var body: some View {
        VStack{
            Form{
                DatePicker("Fecha inicial", selection: $fechaInicial, in: ...Date(), displayedComponents: .date)
                DatePicker("Fecha final", selection: $fechaFinal, in: ...Date(), displayedComponents: .date)
                
                Button(action: {
                   // self.action = 5
                    print(self.fechaInicial)
                    print(self.fechaFinal)
                }){
                    Text("Consultar")
                }.buttonStyle(PrimaryButtonOutlineStyle())
                
            }
     
        }
      
        
        
       
    }
}

struct HistoryDateView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDateView()
    }
}
