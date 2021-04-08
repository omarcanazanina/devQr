//
//  TransactionDetailView.swift
//  fastgi
//
//  Created by Hegaro on 04/11/2020.
//

import SwiftUI

struct TransactionDetailView: View {
    var fecha: String
    var hora: String
    var empresa: String
    var phone: String
    var monto: String
    var control: Int
    //fechaformat
    let date = Date()
    @State var fechaFormat : String
    @State var horaFormat : String
    var showBtn: Bool? = true
    
    let dateFormatter = DateFormatter()
    var dateStringFormatter = DateFormatter()
    //imagen
    @State private var showingAlert = false
    //datos user
    @ObservedObject var userDataVM = UserDataViewModel()
    var navigationRoot = NavigationRoot()
    var FlaseCheck: some View{
        Image(systemName: "xmark")
            .resizable()
            .foregroundColor(Color.white)
            .padding(10)
            .background(Color.red)
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .padding(10)
    }
    var TrueCheck: some View{
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .foregroundColor(Color.green)
            .background(Color.white)
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .padding(10)
    }
    
    var logo: some View{
        Image("logo_fastgi")
            .resizable()
            .frame(width: 80, height: 80)
    }
    
    var vista: some View {
        VStack(alignment: .center, spacing: 10){
            self.logo
                .padding(.top,30)
            Text("Comprobante Electrónico")
                .foregroundColor(.black)
                .font(.title3)
            
            Text("Transferencia de recarga")
                .foregroundColor(.black)
                .padding(.bottom,30)
            
            VStack(alignment: .center, spacing: 10){
                HStack{
                    Text("Nro. TRANSACCIÓN")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("123")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack{
                    Text("FECHA")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    if self.fechaFormat != ""{
                        Text(self.fechaFormat)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }else{
                        Text(self.fecha)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                  
                    
                }
                HStack{
                    Text("HORA")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    if self.horaFormat != ""{
                        Text(self.horaFormat)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }else{
                        Text(self.hora)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                }
                HStack{
                    Text("SERVICIO")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("Recarga \(self.empresa)")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack{
                    Text("ORIGEN")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    //comentado
                    if self.userDataVM.user.nombres == Optional(""){
                        Text ("+591 \(self.userDataVM.user.telefono)")//("\(self.userDataVM.user.nombres) \(self.userDataVM.user.apellidos)")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }else{
                        Text ("\(self.userDataVM.user.nombres ?? "") \(self.userDataVM.user.apellidos ?? "")")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack{
                    Text("NÚMERO")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("+591 \(self.userDataVM.user.telefono)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                HStack{
                    Text("ABONADO")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("Nombre")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack{
                    Text("NÚMERO")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("+591 \(self.phone) ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack{
                    Text("MONTO")
                        .foregroundColor(Color("primary"))
                        .bold()
                        .textStyle(TitleStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("\(self.monto).00 Bs.")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            .onAppear{
                print("el control q llego \(self.control)")
                self.userDataVM.DatosUser()
                if self.control == 1 {
                    //fechaformat
                    print("fecharecibidaaqui\(self.fecha)")
                    dateStringFormatter.dateFormat = "dd/MM/YYYY"// HH:mm:ss"
                    let dateFromString = dateStringFormatter.date(from: self.fecha)
                    self.fechaFormat = dateStringFormatter.string(from: dateFromString ?? date)
                    print("la fechaFormat es \(dateFromString ?? date)")
                    //horaformat
                    dateStringFormatter.dateFormat = "HH:mm:ss"
                    let horaFromString = dateStringFormatter.date(from: self.fecha)
                    self.horaFormat = dateStringFormatter.string(from: horaFromString ?? date)
                }
                    
                
            }
            Spacer()
         
        }
        .background(Color.white)
    }
    
    var body: some View {
        ScrollView{
            VStack(){
                self.vista
                HStack{
                    //if self.showBtn! {
                        Button(action: {
                           // self.exportToPDF(fecha_: self.fechaFormat, empresa_: self.empresa, phone_: self.phone, monto_: self.monto,fechaFormat_: self.fechaFormat, horaFormat_: self.horaFormat, showBtn_: false, nombreO_: self.userDataVM.user.nombres, hora_: self.hora)
                            let image = self.vista.snapshot()
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            showingAlert = true
                        }){
                            Text("Descargar")
                        }.buttonStyle(PrimaryButtonOutlineStyle())
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Fastgi"), message: Text("Descarga completa"), dismissButton: .default(Text("Aceptar")))
                        }
                    //}
                    Button(action: {
                        self.navigationRoot.setRootView()
                    })
                    {
                        Text("Aceptar")
                    }.buttonStyle(PrimaryButtonOutlineStyle())
                }
            }
            .background(Color.white)
        }
    }
}
    struct TransactionDetailView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                TransactionDetailView(fecha: "", hora: "", empresa: "", phone: "", monto: "", control: 0, fechaFormat: "", horaFormat: "")
                    .previewDevice("iPhone 11")
                    .preferredColorScheme(.dark)
            }
        }
    }


extension TransactionDetailView {
    func exportToPDF(fecha_: String, empresa_: String, phone_: String, monto_: String,fechaFormat_: String,horaFormat_:String, showBtn_: Bool, nombreO_: String, hora_: String) {
        
        print(fecha_)
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("Fastgi.pdf")
        
        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let charts = TransactionDetailView(fecha: fecha_, hora: hora_, empresa: empresa_, phone: phone_, monto: monto_, control: 0,fechaFormat: fechaFormat_,horaFormat: horaFormat_, showBtn: showBtn_)
        
        let pdfVC = UIHostingController(rootView: charts)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //Render the view behind all other views
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))
        
        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                pdfVC.view.layer.render(in: context.cgContext)
            })
            
            let items = [outputFileURL]
            
            let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
            

            
        }catch {
            //self.showError = true
            print("Could not create PDF file: \(error)")
        }
        
        pdfVC.removeFromParent()
        pdfVC.view.removeFromSuperview()
    }
    
}
