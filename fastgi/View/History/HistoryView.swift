//
//  HistoryView.swift
//  fastgi
//
//  Created by Hegaro on 04/11/2020.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var loginVM = LoginViewModel()
    @ObservedObject var recargas = Recargas()
    @State private var optionPicker:Int = 0
    @ObservedObject var RecargaVM = RecargaViewModel()
    @ObservedObject var userDataVM = UserDataViewModel()
    //test user
    //var dataUser: UserModel
    //
    @State private var fecha :String = ""
    @State private var hora :String = ""
    @State private var empresa :String = ""
    @State private var phone :String = ""
    @State private var monto :String = ""
    @State private var control : Int = 0
    @State private var action:Int? = 0
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColorPrimary()
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColorPrimary()], for: .normal)
        self.RecargaVM.listRecargas()
    }
    let contacts = ["Herlan Garzon", "Omar Canaza", "Elvin Mollinedo", "Agustin Ayaviri", "Daniel Jaimes", "Amilkar Dominguez"]
    @State private var searchText : String = ""
    var list:some View{
        //ScrollView{
        //NavigationView{
        VStack{
            // SearchBar(text: $searchText, placeholder: "Buscar")
            List {
                /*
                 ForEach(self.contacts.filter {
                 self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                 }, id: \.self) { item in
                 **/
                ForEach(self.RecargaVM.ListRecargas, id: \.self._id){ (recarga:RecargaModel) in
                    Button(action: {
                        print(self.RecargaVM.ListRecargas)
                        self.action = 1
                        self.fecha = recarga.fecha.toStringDateFormat()
                        self.hora = recarga.fecha.toStringDateFormat1()
                        print("esta es la fecha\(self.fecha)")
                        self.empresa = recarga.empresa
                        self.phone = recarga.telefono
                        self.monto = recarga.recarga
                    })
                    {
                        HStack(){
                            VStack(){
                               /* Text(recarga.fecha)
                                    .opacity(0.8)
                                    .font(.caption)
                                    .frame(maxWidth:.infinity, alignment: .leading)*/
                                Text("Tipo")// \(recarga.fecha)")
                                    .font(.caption)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                Text(recarga.telefono)//fecha)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                            }.frame(maxWidth:.infinity, alignment: .leading)
                            Spacer()
                            VStack(){
                                Text("\(recarga.recarga).00 Bs.")
                            }
                            
                        }
                        
                    }
                    
                }
            }
            /* NavigationLink(destination: TransactionDetailView(), tag: "detail", selection: self.$login.ruta) {
             EmptyView()
             }*/
        }.offset(y:-15)
        
        //}
        
        
    }
    
    var listNot:some View{
        //ScrollView{
        VStack{
            SearchBar(text: $searchText, placeholder: "Buscar")
            List {
                ForEach(self.contacts.filter {
                    self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                }, id: \.self) { item in
                    //Item of list
                    Button(action: {
                        //self.RecargaVM.listRecargas()
                        // print(self.RecargaVM.ListRecargas)
                        //self.recargas.ListRecargas()
                    })
                    {
                        HStack(){
                            VStack(){
                                Text(item)
                                    .opacity(0.8)
                                    .font(.caption)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                Text("Tipo")
                                    .font(.caption)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                Text("14/09/2020 16:50")
                                    .frame(maxWidth:.infinity, alignment: .leading)
                            }.frame(maxWidth:.infinity, alignment: .leading)
                            Spacer()
                            VStack(){
                                Text("50.00 Bs.")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    var body: some View {
        VStack {
            Button(action: {
                self.action = 5
            }){
                Text("Filtrar")
            }
            NavigationLink(destination: CalendarView(), tag: 5, selection: self.$action) {
                EmptyView()
            }
            VStack{
                Picker(selection: $optionPicker, label: Text("")) {
                    Text("Realizadas").tag(0)
                    Text("No realizadas").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                if(optionPicker==0){
                    self.list
                    NavigationLink(destination: TransactionDetailView(fecha: self.fecha, hora: self.hora, empresa: self.empresa, phone: self.phone, monto: self.monto, dataUser: self.userDataVM.user, control: 0, fechaFormat: "", horaFormat: ""), tag: 1, selection: self.$action) {
                        EmptyView()
                    }
                }
                if(optionPicker==1){
                    //Text("list no realizadas")
                    self.listNot
                }
            }
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

extension String{
    func toStringDateFormat() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let oldDate = olDateFormatter.date(from: self)

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd/MM/yyyy"

        return convertDateFormatter.string(from: oldDate ?? Date())
    }
    func toStringDateFormat1() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let oldDate = olDateFormatter.date(from: self)

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "HH:mm:ss"

        return convertDateFormatter.string(from: oldDate ?? Date())
    }
    func dateDiff() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let oldDate = olDateFormatter.date(from: self)
        let units = Array<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(Set(units), from: oldDate!, to: Date())
        var  text = ""
        var  unidad = ""
        for unit in units
        {
            guard let value = components.value(for: unit) else {
                continue
            }

            if value > 0 {
                switch unit {
                case .day:
                    unidad = value == 1 ? "dia" : "dias"
                case .month:
                    unidad = value == 1 ? "mes" : "meses"
                case .year:
                    unidad = value == 1 ? "año" : "años"
                case .hour:
                    unidad = value == 1 ? "hora" : "horas"
                case .minute:
                    unidad =  value == 1 ? "minuto" : "minutos"
                case .second:
                    unidad = value == 1 ? "segundo" : "segundos"
                case .weekday:
                    unidad = value == 1 ? "semana" : "semanas"
                default:
                        unidad = ""
                }
                text =  "hace \(value) \(unidad) "
                break
            }else{
                text =  "ahora"
            }
        }
        return text;
    }
}

