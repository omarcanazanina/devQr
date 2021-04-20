//
//  QrPaymentModuleModel.swift
//  fastgi wallet
//
//  Created by Hegaro on 16/04/2021.
//

import Foundation

struct QrPaymentModuleModel : Codable { //,Identifiable {
    let _id : String
    let monto : String
    let id_cobrador : String
    let id_usuario : String
    let fecha : String
}



struct ErrorQrPaymentModuleModel : Codable{
    var name: String
    var message: String
}

struct CobroQrModuleModel : Codable { //,Identifiable {
    let _id : String
    //let empresa : String
    let id_cobrador : String
    let id_usuario : String
   //let telefono : String
    let fecha : String
}

struct PagoQrModuleModel : Codable { //,Identifiable {
    let _id : String
    //let empresa : String
    let id_cobrador : String
    let id_usuario : String
   //let telefono : String
    let fecha : String
}

//error de token recarga
struct ErrorQrModule : Codable{
    var name: String
    var message: String
}
