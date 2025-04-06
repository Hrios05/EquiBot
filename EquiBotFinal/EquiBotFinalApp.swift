//
//  EquiBotFinalApp.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/4/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct EquiBotFinalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        @State private var isShowingContentView = true

        var body: some Scene {
            WindowGroup {
                if isShowingContentView {
                    ContentView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isShowingContentView = false
                            }
                        }
                } else {
                    LoginView()
                }
            }
        }
}
