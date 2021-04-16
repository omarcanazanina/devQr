//
//  TestView.swift
//  fastgi wallet
//
//  Created by Hegaro on 24/03/2021.
//

import SwiftUI
import UIKit
import PopupView
struct TestView: View {
    @State var isShowingPopUp = false
    
    var body: some View {
            VStack{
                Button(action: {
                    self.isShowingPopUp = true
                })
                {
                    Text("test")
                        
                } .popup(isPresented: $isShowingPopUp, type: .floater(verticalPadding: 80), position: .top, animation: .easeIn, autohideIn: 3, closeOnTap: true, closeOnTapOutside: false, view: {
                    Toast()
                })
               
              
            }
      
      
       // Home()
       
    }
}

struct Toast : View {
    var body: some View {
        ZStack{
            Color.green
            HStack{
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 35,height: 35,alignment: .center)
                    .foregroundColor(Color.white )
                    .padding()
                Text("Esta es una notificacion ")
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 45)
        .cornerRadius(12)
        .padding()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct Home : View{
    @State var items : [Any] = []
    @State var sheet = false
    
    var body: some View{
        VStack{
            Button(action: {
                items.removeAll()
                items.append(UIImage(named: "Up")!)
                sheet.toggle()
            }) {
                Text("Share")
                    .fontWeight(.heavy)
            }
            .sheet(isPresented: $sheet, content: {
                ShareSheet(items: items)
            })
            //opcion 2
            Button(action: {
                // actionSheet
                actionSheetTest(info: "jhbjh")
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            
            //opcion 3
         
            Button(action: {
               
            }) {
                Text("prueba 3")
            }
        }
    }
    
    func prueba3(){
        let items = ["Mi_teleferico"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
      
        ac.present(ac, animated: true)
    }
    
   
    
    
    
    
    func actionSheet() {
           guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
           let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
       }
    
    func actionSheetTest(info:Any) {
        let infoU = info
        let av = UIActivityViewController(activityItems: [infoU], applicationActivities: nil)
           //guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
           //let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2.1, y: UIScreen.main.bounds.height / 1.3, width: 200, height: 200)
        }
       }
    //
    func opcion3(){
        guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://www/google.com")else {
            return
        }
        let shareSheetVC = UIActivityViewController(activityItems: [image,url], applicationActivities: nil)
            
        //present(shareSheetVC, animated: true)
    }
}


// share
struct ShareSheet1 : UIViewControllerRepresentable {
    var items : [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}




