//
//  APIProvidedView.swift
//  Demo
//
//  Created by Sihao Lu on 4/7/23.
//

import DemoChat
import OpenAI
import SwiftUI

struct APIProvidedView: View {
    @Binding var apiKey: String
    @StateObject var chatStore: ChatStore
    @StateObject var miscStore: MiscStore
    @State var isShowingAPIConfigModal: Bool = true

    @Environment(\.idProviderValue) var idProvider
    @Environment(\.dateProviderValue) var dateProvider

    init(
        apiKey: Binding<String>,
        idProvider: @escaping () -> String
    ) {
        self._apiKey = apiKey
        self._chatStore = StateObject(
            wrappedValue: ChatStore(
                openAIClient: OpenAI(apiToken: apiKey.wrappedValue),
                idProvider: idProvider
            )
        )
        self._miscStore = StateObject(
            wrappedValue: MiscStore(
                openAIClient: OpenAI(apiToken: apiKey.wrappedValue)
            )
        )
    }

    var body: some View {
        ContentView(
            chatStore: chatStore,
            miscStore: miscStore
        )
        .onChange(of: apiKey) { newApiKey in
            chatStore.openAIClient = OpenAI(apiToken: newApiKey)
        }
    }
}
