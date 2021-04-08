//
//  HomeView.swift
//  fastgi
//
//  Created by Hegaro on 04/11/2020.
//

import SwiftUI
import Introspect
//lectorqr
import CodeScanner
import Foundation
struct HomeView: View {
    var navigationRoot = NavigationRoot()
    
    @ObservedObject var login = Login()
    @ObservedObject var loginVM = LoginViewModel()
    @Binding var currentBtnEm: BtnEm
    //pagoQR
    @ObservedObject var qrPayment = QrPayment()
    @ObservedObject var qrPaymentVM = QrPaymentViewModel()
    @ObservedObject var userData = UserData()
    @ObservedObject var userDataVM = UserDataViewModel()
    @ObservedObject var contactsVM = ContactsViewModel()
    //lector qr
    @State private var showScannerTeleferico = false
    @State private var showScannerTransporte = false
    @State private var showScannerScan = false
    @State private var resultado = ""
    @State private var resultadosScan = ""
    //lector con monto
    @State private var idconmonto = ""
    @State private var montoQR = ""
    
    @State private var action:Int? = 0
  //lector modulo PAGO con monto
    @State private var montoPagoQR = ""
    @State private var montoCobroQR = ""
    //modal test
    @State private var showScannerTransporte1 = false
    @State var modal = false
  
    //calendar
    //@State private var birthdate = Date()
 
    // compartir img
    @State var items : [Any] = []
    @State var sheet = false
  
   
    init(currentBtnEm: Binding<BtnEm>) {
        self._currentBtnEm = currentBtnEm
        //Config for NavigationBar Transparent
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        //self.contactsVM.getContacts()
        self.userDataVM.DatosUser()
    }
    
    var btnTeleferic:some View{
        HStack{
            Button(action: {
               // self.showScannerTeleferico = true
                self.action = 99
            }){
                VStack{
                    Image("Teleferico")
                        .resizable()
                        .frame(width:80, height: 80)
                        .padding(10)
                }
                .background(Color("card"))
                .cornerRadius(10)
                .frame(maxWidth:.infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            }
            NavigationLink(destination: QrTelefericoView(dataUserlog: self.userDataVM.user), tag: 99, selection: self.$action) {
                EmptyView()
            }
        }
      
      
        //.background(Color.red.opacity(0.5))
        /*.sheet(isPresented: self.$showScannerTeleferico) {
            CodeScannerView(codeTypes: [.qr]){ result in
                switch result {
                case .success(let codigo):
                    print("teleferico")
                    self.resultado = codigo
                    self.showScannerTeleferico = false
                    //self.action = 1
                case .failure(let error):
                    print(error.localizedDescription)
                }
                NavigationLink(destination: QrGeneratorView( dataUserlog: self.userDataVM.user), tag: 1, selection: self.$action) {
                    EmptyView()
            }
            }
        }*/
       
  
    }
    
    var btnTransport:some View{
        HStack{
            Button(action: {
                self.showScannerTransporte = true
                self.action = 1
               
            }){
                HStack{
                    Image("Transport")
                        .resizable()
                        .frame(width:80, height: 80)
                        .padding(10)
                }
                .background(Color("card"))
                .cornerRadius(10)
                .frame(maxWidth:.infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                
            }
            //.background(Color.blue.opacity(0.5))
            .sheet(isPresented: self.$showScannerTransporte) {
                CodeScannerView(codeTypes: [.qr,.code128]){ result in
                    switch result {
                    case .success(let codigo):
                        self.resultado = codigo
                        if self.resultado.count > 24 {
                            self.idconmonto = String(self.resultado.prefix(24))
                            print("tiene monto \(self.idconmonto)")
                            self.montoQR = String(self.resultado.dropFirst(24))
                            print("el monto \(self.montoQR)")
                            self.qrPaymentVM.userAfiliacion(id_afiliado: self.idconmonto)
                            self.showScannerTransporte = false
                        }else{
                            print("no tiene monto")
                            self.qrPaymentVM.userAfiliacion(id_afiliado: self.resultado)
                            self.showScannerTransporte = false
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .onReceive(self.qrPaymentVM.$afiliado) { (afiliado) in
                if afiliado == true {
                    print("entro onreceive")
                    self.userDataVM.DatosUserPago(id_usuario: self.resultado)
                    if self.idconmonto == ""{
                        self.userDataVM.DatosUserPago(id_usuario: self.resultado)
                       // self.navigationRoot.testFocusNav(user: self.userDataVM.userResponsePago, montoqr: self.$montoQR)
                    }else{
                        self.userDataVM.DatosUserPago(id_usuario: self.idconmonto)
                       //self.navigationRoot.testFocusNav(user: self.userDataVM.userResponsePago, montoqr: self.$montoQR)
                    }
                  
                }
            }
          
            NavigationLink(destination: PayView(User: self.userDataVM.userResponsePago, montoQR: self.$montoQR), isActive: self.$userDataVM.nextPagoview) {
                EmptyView()
            }
        }
      
    }
    
    var btnScan:some View{
        HStack{
            Button(action: {
                self.showScannerScan = true
                //self.action = 2
               
            }){
                HStack{
                    VStack{
                        Image(systemName: "viewfinder")
                            .resizable()
                            .frame(width:35, height: 35)
                            .padding(15)
                            .foregroundColor(Color.white)
                        Text("Scan")
                            .foregroundColor(Color.white)
                            .font(.headline)
                    }
                    
                }
                 .frame(width:100, height: 100)
                 .background(Color("primary"))
                 .cornerRadius(10)
                 .padding(5)
                 //
                
                 .frame(maxWidth:.infinity)
                 //.shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            }
            //.background(Color.blue.opacity(0.5))
            .sheet(isPresented: self.$showScannerScan) {
                CodeScannerView(codeTypes: [.qr,.code128]){ result in
                    switch result {
                    case .success(let codigo):
                        self.resultadosScan = codigo
                        //aqui
                        if self.resultadosScan.hasPrefix("pagar"){
                            let scanDividido: [Substring] = self.resultadosScan.split(separator: ",")
                            if scanDividido.count == 2 {
                                self.userDataVM.DatosUserPay(id_usuario: String(scanDividido[1]))
                                 self.showScannerScan = false
                                 self.action = 10
                            }else{
                                self.userDataVM.DatosUserPay(id_usuario: String(scanDividido[1]))
                                 self.showScannerScan = false
                                 self.action = 10
                                self.montoPagoQR = String(scanDividido[2])
                                print("el primero \(scanDividido[0])")
                                print("el segundo \(scanDividido[1])")
                                print("el tercero \(scanDividido[2])")
                            }
                            
                        }else{
                            let scanDivididoCobrar: [Substring] = self.resultadosScan.split(separator: ",")
                            if scanDivididoCobrar.count == 1{
                                print("no tiene pagar \(self.resultadosScan)")
                                self.userDataVM.DatosUserPay(id_usuario: String(scanDivididoCobrar[0]))
                                self.showScannerScan = false
                                self.action = 11
                            }else{
                                self.userDataVM.DatosUserPay(id_usuario: String(scanDivididoCobrar[0]))
                                self.showScannerScan = false
                                self.action = 11
                                self.montoCobroQR = String(scanDivididoCobrar[1])
                            }
                            
                        }
                       // self.userDataVM.DatosUserPay(id_usuario: self.resultadosScan)
                       // print("aki \(self.userDataVM.userResponsePay)")
                        self.showScannerScan = false
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .onReceive(self.userDataVM.$userResponsePay) { (userPay) in
                if userPay._id == "ObjectId"{
                    print("no hay user")
                }else{
                    print("usuario existe")
                  
                }
              
            }
            NavigationLink(destination: ChargeView(dataUserPay: self.userDataVM.userResponsePay, montoCobroQR: self.$montoCobroQR), tag: 11, selection: self.$action) {
                EmptyView()
            }
            NavigationLink(destination: PayScanView(dataUserPay: self.userDataVM.userResponsePay, montoPagoQR: self.$montoPagoQR), tag: 10, selection: self.$action) {
                EmptyView()
            }
           /* NavigationLink(destination: ChargeView(dataUserPay: self.userDataVM.userResponsePay), isActive: self.$userDataVM.nextPayview) {
                EmptyView()
            }*/
        }
    }
    
   
    
    var btnPay:some View{
        HStack{
            Button(action: {
                self.action = 4
            }){
                HStack{
                    VStack{
                        Image(systemName: "barcode")
                            .resizable()
                            .frame(width:35, height: 35)
                            .padding(15)
                            .foregroundColor(Color.white)
                        Text("Pagar")
                            .foregroundColor(Color.white)
                            .font(.headline)
                    }
                    
                }
                 .frame(width:100, height: 100)
                 .background(Color("primary"))
                 .cornerRadius(10)
                 .padding(5)
                 //
                
                 .frame(maxWidth:.infinity)
                 .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            }
            NavigationLink(destination: QrChargeView(dataUserlog: self.userDataVM.user, dataString: ""), tag: 4, selection: self.$action) {
                EmptyView()
            }
        }
    }
    
    var btnIngresar:some View{
        HStack{
            Button(action: {
                self.action = 3
            }){
                HStack{
                    VStack{
                        Image(systemName: "qrcode")
                            .resizable()
                            .frame(width:35, height: 35)
                            .padding(15)
                            .foregroundColor(Color.white)
                        Text("Recibir")
                            .foregroundColor(Color.white)
                            .font(.headline)
                    }
                    
                }
                .frame(width:100, height: 100)
                .background(Color("primary"))
                .cornerRadius(10)
                .padding(5)
                //
               
                .frame(maxWidth:.infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            }
            NavigationLink(destination: QrPayView( dataUserlog: self.userDataVM.user), tag: 3, selection: self.$action) {
                EmptyView()
            }
        }
    }
    
    var btnRegisterCard:some View{
        HStack{
            Button(action: {
                self.action = 12
            }){
                HStack{
                    VStack{
                        Image(systemName: "creditcard")
                            .resizable()
                            .frame(width:20, height: 20)
                            .padding(25)
                            .foregroundColor(Color.white)
                        Text("Registro")
                            .foregroundColor(Color.white)
                            .font(.headline)
                    }
                    
                }
                // .frame(width:100, height: 100)
                 .background(Color("primary"))
                 .cornerRadius(10)
                 .padding(5)
                 //
                
                 .frame(maxWidth:.infinity)
                 .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            }
            NavigationLink(destination: ListCreditCardView(), tag: 12, selection: self.$action) {
                EmptyView()
            }
        }
    }
    
    var home:some View{
        ScrollView{
            VStack{
               // self.pickerBank
                HStack(spacing:10){
                    self.btnScan
                    self.btnPay
                    self.btnIngresar
                    //self.btnRegisterCard
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                VStack{
                    Text("Recarga de línea pre pago")
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.vertical,10)
                    HStack{
                        CardServiceHomeView( logo: "Entel", isSelect: false, currentBtnEm: self.$currentBtnEm, btn: .Entel)
                        CardServiceHomeView(logo: "Viva", isSelect: false, currentBtnEm: self.$currentBtnEm, btn: .Viva)
                        CardServiceHomeView(logo: "Tigo", isSelect: false, currentBtnEm: self.$currentBtnEm, btn: .Tigo)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                VStack{
                    Text("Transportes")
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.vertical,10)
                    HStack(spacing:10){
                        self.btnTeleferic
                        self.btnTransport
                        //self.btnTransport1
                        Spacer()
                            .frame(maxWidth:.infinity)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                VStack{
               Button(action: {
                   self.action = 44
               }){
                 //Text("test1")
                 }
                    
                    NavigationLink(destination: DetalleTelefericoView(), tag: 44, selection: self.$action) {
                 EmptyView()
                 }
                    /* //modal test
                    Button(action: {
                        self.modal.toggle()
                    }){
                        Text("testModal")
                    }    .sheet(isPresented: $modal) {
                        TestModalView(modal: $modal)
                    }
                    */
                 }
                
                Button("") {
                    //showingAlert1 = true
                }
                .alert(isPresented: self.$qrPaymentVM.alertNoAfiliado) {
                    Alert(title: Text("Fastgi"), message: Text("Usuario no afiliado."), dismissButton: .cancel())
                }
                
                Button("") {
                    // showingAlert2 = true
                }
                .alert(isPresented: self.$userDataVM.alertInexistente) {
                    Alert(title: Text("Fastgi"), message: Text("Usuario inexistente."), dismissButton: .cancel())
                }
            }
         
        }
    
        .padding()
       
    }
    
    
    var body: some View {
        VStack{
            self.home
           // DatePicker("calendar", selection: $birthdate, in: ...Date(), displayedComponents: .date)
           
            
           // Text(self.resultadosScan)
            Button(action: {
                self.action = 15
            }){
                Text("Caja")
            }
            
            NavigationLink(destination: FormLoadBoxView(MontoRecarga1: .Btn30) , tag: 15, selection: self.$action) {
         EmptyView()
         }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentBtnEm: .constant(.Entel))
            
    }
}

