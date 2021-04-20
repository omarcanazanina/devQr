//
//  QrPaymentModuleResponse.swift
//  fastgi wallet
//
//  Created by Hegaro on 16/04/2021.
//

import Foundation


struct QrPaymentModuleResponse : Codable {
    let ok : Bool
    let recarga : QrPaymentModuleModel
}

struct ErrorQrPaymentModuleResponse : Codable {
    var ok : Bool
    var err : ErrorQrPaymentModuleModel
}
//historial

struct GetCobrosQrResponse : Codable {
    let ok :Bool
    let recarga: [CobroQrModuleModel]
}
struct ErrorCobroQrResponse : Codable {
    var ok : Bool
    var err : ErrorQrModule
}

struct GetPagosQrResponse : Codable {
    let ok :Bool
    let recarga: [PagoQrModuleModel]
}
struct ErrorPagoQrResponse : Codable {
    var ok : Bool
    var err : ErrorQrModule
}
