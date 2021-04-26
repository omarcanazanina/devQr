//
//  RequestMoneyView.swift
//  fastgi wallet
//
//  Created by Hegaro on 26/04/2021.
//

import SwiftUI

struct RequestMoneyView: View {
    @ObservedObject var contactsVM = ContactsViewModel()
    @ObservedObject var contacts = Contacts()
    @State var showingSheet = false
    @State private  var nombreContact = ""
    @State private  var telefono = ""
    @State private  var monto = ""
    var body: some View {
        ScrollView{
            VStack( spacing: 20){
                HStack{
                    TextField("Ingrese Monto", text: $monto)
                        .padding(.horizontal,12)
                        .padding(.vertical,8)
                        .keyboardType(.numberPad)
                        //.cornerRadius(25)
                        .introspectTextField { (textField) in
                            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                            let doneButton = UIBarButtonItem(title: "Cerrar", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                         doneButton.tintColor = .darkGray
                            toolBar.items = [flexButton, doneButton]
                            toolBar.setItems([flexButton, doneButton], animated: true)
                            textField.inputAccessoryView = toolBar
                         }
                }.background(Color("input"))
                HStack{
                    TextField("Número de teléfono", text: $telefono)
                        .padding(.horizontal,12)
                        .padding(.vertical,8)
                        .keyboardType(.numberPad)
                        //.cornerRadius(25)
                        .introspectTextField { (textField) in
                            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                            let doneButton = UIBarButtonItem(title: "Cerrar", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                         doneButton.tintColor = .darkGray
                            toolBar.items = [flexButton, doneButton]
                            toolBar.setItems([flexButton, doneButton], animated: true)
                            textField.inputAccessoryView = toolBar
                         }
                    Button(action: {
                        if self.contactsVM.listContacts.count == 0{
                                print("no hay contactos")
                                //print(self.contContacts)
                                self.contacts.sendContacts()
                                self.contactsVM.getContacts()
                            }else{
                                print("si hay contactos")
                                //print(self.contContacts)
                                self.showingSheet.toggle()
                            }
                    })
                    {
                        Image(systemName: "person.2")
                            .foregroundColor(Color("primary"))
                            .padding(12)
                    }
                    //ListcontactsView
                    .sheet(isPresented: $showingSheet) {
                        ListContactsView(showingSheet: self.$showingSheet, telefono: self.$telefono, nombre: self.$nombreContact, modal: self.$showingSheet, listAllContacts: self.$contactsVM.listContacts )
                    }
                    //end
                }.background(Color("input"))
            }.padding()
            HStack{
                Button(action: {
                    //self.action = 2
                }) {
                        Text("Pedir")
                            .foregroundColor(Color.white)
                            .frame(maxWidth:.infinity)
                            .padding(8)
                            .background(Color("primary"))
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
                            .padding()
                }
            }
          
            
        }.navigationTitle("Pedir dinero")
        .onAppear{
           //self.userDataVM.DatosUser()
           self.contactsVM.getContacts()
       }
    }
}

struct RequestMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        RequestMoneyView()
    }
}
