//
//  Login.swift
//  fastgi
//
//  Created by Hegaro on 04/11/2020.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import SDWebImageSwiftUI

class Login: ObservableObject {
    @Published var ruta: String? = ""
    @Published var isloading = false
    @Published var iscomplete = false
    @Published var loginResponse = false
    @Published var messageError :String = ""
    //sms por el momento
    //@Published var pin :Usuario?
    @EnvironmentObject private var authState : AuthState
    private let tokenKey = "token"
    private let idKey = "usuario._id"
    private let tokenDevice = "tokenDevice"
    //Storage
    private let storage = UserDefaults.standard
    //rutas
    var navigationRoot = NavigationRoot()
    //datauser
    @Published var userResponse:UpdateUserModel?
    //pin
    @Published var smstext :String = ""
    
    func loginDetail(telefono:String) {
        self.isloading = true
        let parametros : Parameters = [
            "telefono": telefono
        ]
        guard let url = URL(string: "https://api.fastgi.com/sms") else { return }
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parametros)
                .responseData { (response) in
                    switch response.result {
                    case let .success(data):
                        //Cast respuesta a SmsResponse
                        if let decodedResponse = try? JSONDecoder().decode(SmsResponse.self, from: data) {
                            print(decodedResponse.usuario)
                            //self.pin = decodedResponse.usuario
                            self.smstext = decodedResponse.usuario.pin
                            print("este es el sms \(self.smstext)")
                            self.ruta = "idlogin"
                            self.isloading = false
                            self.iscomplete = true
                            self.navigationRoot.setRootViewNav(number: telefono, smstext: self.smstext)
                            return
                        }
                        //Cast respuesta a ErrorResponce
                        if let decodedResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            print(decodedResponse.err.message)
                            //  self.ErrorRes = decodedResponse.err.message
                            self.isloading = false
                            self.iscomplete = true
                            return
                        }
                    case let .failure(error):
                        self.isloading = false
                        print(error)
                    }
                }
        }
    }
    
    func confirmCode(telefono:String,pin:String) {
       // self.iscomplete = false
        self.isloading = true
        print("desde el login \(storage.string(forKey: tokenDevice))")
        let parametros : Parameters = [
            "telefono": telefono,
            "pin": pin
        ]
        guard let url = URL(string: "https://api.fastgi.com/loginsms") else { return }
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parametros)
                .responseData { (response) in
                    switch response.result {
                    case let .success(data):
                        //Cast respuesta a LoginSmsResponse
                        if let decodedResponse = try? JSONDecoder().decode(LoginSmsResponse.self, from: data) {
                            print(decodedResponse.usuario)
                            //sesion
                            self.storage.set(decodedResponse.token, forKey: self.tokenKey)
                            self.storage.set(decodedResponse.usuario._id, forKey: self.idKey)
                            SDWebImageDownloader.shared.setValue(decodedResponse.token, forHTTPHeaderField: "token")
                            print(decodedResponse)
                            //
                            self.loginResponse = true
                            // self.authState.isAuth = true
                            self.isloading = false
                            self.iscomplete = true
                            self.navigationRoot.setRootView()
                            return
                        }
                        //Cast respuesta a ErrorResponce
                        if let decodedResponse = try? JSONDecoder().decode(ErrorSmsResponse.self, from: data) {
                            print(decodedResponse.err.message)
                            self.messageError = decodedResponse.err.message
                            //print(self.messageError)
                            self.isloading = false
                            self.iscomplete = true
                            return
                        }
                    case let .failure(error):
                        self.isloading = false
                        self.iscomplete = true
                        self.messageError = "Código incorrecto "
                        print(error)
                    }
                }
        }
        
    }
    
    
    
}
