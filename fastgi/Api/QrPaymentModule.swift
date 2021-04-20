//
//  QrPaymentModule.swift
//  fastgi wallet
//
//  Created by Hegaro on 16/04/2021.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class QrPaymentModule: ObservableObject {
    private let storage = UserDefaults.standard
    private let tokenKey = "token"
    private let idKey = "usuario._id"
    @Published var cobroResponse: QrPaymentModuleModel?
    @Published var getCobrosResponse: GetCobrosQrResponse?
    @Published var getPagosResponse: GetPagosQrResponse?
    func cobroQr(id_cobrador:String, monto:String){
        let parametros : Parameters = [
            "id_cobrador": id_cobrador,
            "monto": monto
        ]
        
        // creando headers
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        if let token = storage.string(forKey: tokenKey){
            headers.add(name: "token", value: token)
        }
        
        let idusu = storage.string(forKey: idKey)!
        guard let url = URL(string: "https://api.fastgi.com/transtrans/\(idusu)") else { return }
        DispatchQueue.main.async {
            AF.request(url,method:.post,parameters: parametros,headers: headers )
                // .validate(contentType: ["application/json"])
                .responseData{response in
                    switch response.result {
                    case let .success(data):
                        if let decodedResponse = try? JSONDecoder().decode(QrPaymentModuleResponse.self, from: data) {
                            //print(decodedResponse.recarga)
                            self.cobroResponse = decodedResponse.recarga
                           // print(self.pagoResponse!)
                            return
                        }
                        //Cast respuesta a ErrorResponce
                        if let decodedResponse = try? JSONDecoder().decode(ErrorQrPaymentModuleResponse.self, from: data) {
                            print("ESTE ES EL ERROR \(decodedResponse.err.message)")
                            //  self.ErrorRes = decodedResponse.err.message
                            return
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        }
        
    }
    
    func pagoQr(id_cobrador:String, monto:String){
        let parametros : Parameters = [
            "id_cobrador": id_cobrador,
            "monto": monto
        ]
        
        // creando headers
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        if let token = storage.string(forKey: tokenKey){
            headers.add(name: "token", value: token)
        }
        
        let idusu = storage.string(forKey: idKey)!
        guard let url = URL(string: "https://api.fastgi.com/transtrans/\(idusu)") else { return }
        DispatchQueue.main.async {
            AF.request(url,method:.post,parameters: parametros,headers: headers )
                // .validate(contentType: ["application/json"])
                .responseData{response in
                    switch response.result {
                    case let .success(data):
                        if let decodedResponse = try? JSONDecoder().decode(QrPaymentModuleResponse.self, from: data) {
                            //print(decodedResponse.recarga)
                            self.cobroResponse = decodedResponse.recarga
                           // print(self.pagoResponse!)
                            return
                        }
                        //Cast respuesta a ErrorResponce
                        if let decodedResponse = try? JSONDecoder().decode(ErrorQrPaymentModuleResponse.self, from: data) {
                            print("ESTE ES EL ERROR \(decodedResponse.err.message)")
                            //  self.ErrorRes = decodedResponse.err.message
                            return
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        }
        
    }
    
    func ListCobrosQr(){
          // creando headers
          var headers: HTTPHeaders = [
              "Accept": "application/json"
          ]
          if let token = storage.string(forKey: tokenKey){
              headers.add(name: "token", value: token)
          }
          //"5f56de014e834e3bc4c02059"
          let idusu = storage.string(forKey: idKey)!
              guard let url = URL(string: "https://api.fastgi.com/historial/\(idusu)") else { return }
       //print("este es el idusuariolist recargas\(idusu)")
              DispatchQueue.main.async {
                  AF.request(url,method:.get,headers: headers )
                      //.validate(contentType: ["application/json"])
                      .responseData{response in
                       //debugPrint(response)
                          switch response.result {
                          case let .success(data):
                              //Cast respuesta a MeResponce
                              if let decodedResponse = try? JSONDecoder().decode(GetCobrosQrResponse.self, from: data) {
                              // print(decodedResponse.recarga)
                               self.getCobrosResponse=decodedResponse
                               print(self.getCobrosResponse?.recarga ?? "")
                                  return
                              }
                          case let .failure(error):
                              print(error)
                          }
                  }
              }
      }
    
    func ListPagosQr(){
          // creando headers
          var headers: HTTPHeaders = [
              "Accept": "application/json"
          ]
          if let token = storage.string(forKey: tokenKey){
              headers.add(name: "token", value: token)
          }
          //"5f56de014e834e3bc4c02059"
          let idusu = storage.string(forKey: idKey)!
              guard let url = URL(string: "https://api.fastgi.com/historial/\(idusu)") else { return }
       //print("este es el idusuariolist recargas\(idusu)")
              DispatchQueue.main.async {
                  AF.request(url,method:.get,headers: headers )
                      //.validate(contentType: ["application/json"])
                      .responseData{response in
                       //debugPrint(response)
                          switch response.result {
                          case let .success(data):
                              //Cast respuesta a MeResponce
                              if let decodedResponse = try? JSONDecoder().decode(GetPagosQrResponse.self, from: data) {
                              // print(decodedResponse.recarga)
                               self.getPagosResponse=decodedResponse
                               print(self.getPagosResponse?.recarga ?? "")
                                  return
                              }
                          case let .failure(error):
                              print(error)
                          }
                  }
              }
      }
    
}
