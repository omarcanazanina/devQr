//
//  MembershipView.swift
//  fastgi
//
//  Created by Hegaro on 24/11/2020.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import CarBode
struct MembershipView: View {
    @State private var action:Int? = 0
    @ObservedObject var afiliacionVM = AfiliacionViewModel()
    //datos user
    @ObservedObject var userDataVM = UserDataViewModel()
    //alerta
    @State var alertState: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var showBtn: Bool? = true
    //
    //barcode generator
    @State var dataString : String = ""
    @State var barcodeType = CBBarcodeView.BarcodeType.barcode128
    @State var rotate = CBBarcodeView.Orientation.up
    @State var barcodeImage: UIImage?
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColorPrimary()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColorPrimary()], for: .normal)
        self.userDataVM.DatosUser1()
        self.afiliacionVM.verifiAffiliate(id_cobrador: self.userDataVM.user1._id)
        
    }
    
    func generarQR(text: String) -> UIImage{
        let data = Data(text.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let img = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage:img).resized(toWidth: 512) ?? UIImage()
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var imageProfile:some View {
        HStack(alignment: .center){
                WebImage(url: URL(string: "https://i.postimg.cc/8kJ4bSVQ/image.jpg" ))
                    .onSuccess { image, data, cacheType in
                    }
                    .placeholder(Image( "user-default"))
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                    .overlay(
                        Circle()
                            .stroke(Color("card"), lineWidth: 2))
            
        }
        
    }
    
    var afiliacion: some View {
        ScrollView{
            VStack{
                
                Text("Seleccione servicio")
                    .font(.caption)
                    //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.vertical,10)
                HStack{
                    Button(action: {
                        self.action = 1
                    }){
                        HStack(spacing:10){
                            Image("Transport")
                                .resizable()
                                .frame(width:80, height: 80)
                                .padding(10)
                                //Spacer()
                                //.frame(maxWidth:.infinity)
                        }
                        .background(Color("card"))
                        .cornerRadius(10)
                        //.frame(maxWidth:.infinity)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                        
                    }
                    NavigationLink(destination: SlideFormJoinView(user: self.userDataVM.user1, nombreCompleto: "\(self.userDataVM.user1.nombres) \(self.userDataVM.user1.apellidos)" ), tag: 1, selection: self.$action) {
                        EmptyView()
                    }
                }
            }
        }
        .padding()
    }
    var body: some View {
                HStack{
                    if self.afiliacionVM.afiliacionHabilitacion._id == "" {
                        self.afiliacion
                    }else if self.afiliacionVM.afiliacionHabilitacion.habilitado == false{
                        Text("afiliación en progreso")
                    }else if self.afiliacionVM.afiliacionHabilitacion.habilitado == true{
                        VStack{
                            self.imageProfile
                            if self.userDataVM.user1.nombres == Optional(""){
                                Text("+591 \(self.userDataVM.user1.telefono)")
                                    .bold()
                            }else{
                                Text("\(self.userDataVM.user1.nombres) \(self.userDataVM.user1.apellidos)")
                                    .bold()
                            }
                            //barcode
                            CBBarcodeView(data: .constant(self.userDataVM.user1._id) ,
                                barcodeType: $barcodeType,
                                orientation: $rotate)
                                { image in
                                    self.barcodeImage = image
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .topLeading)
                            
                            Image(uiImage: generarQR(text: self.userDataVM.user._id))
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        Text("su afiliación ya fue aprobada")
                            
                            if self.showBtn! {
                                Button(action: {
                                    self.exportToPDF()
                                }){
                                    Text("Compartir")
                                }.buttonStyle(PrimaryButtonOutlineStyle())
                                
                            }
                        }
                    }
                    
                }
            
       /* .alert(isPresented:  self.$alertState){
            self.alerts
        }*/
    }
    
    var alerts:Alert{
        Alert(title: Text("Fastgi"), message: Text("Su afiliación esta en proceso verifique de algunos minutos por favor."), dismissButton: .default(Text("Aceptar"), action: {
            self.presentationMode.wrappedValue.dismiss()
        }))
    }
    
}

struct MembershipView_Previews: PreviewProvider {
    static var previews: some View {
        MembershipView()
    }
}


extension MembershipView {
    func exportToPDF() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("Fastgi.pdf")
        
        //Normal with
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let charts = MembershipView()
        
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


