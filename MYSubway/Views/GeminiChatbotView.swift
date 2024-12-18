//
//  GeminiChatbotView.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/15/24.
//

import SwiftUI

struct GeminiChatbotView: View {
    @State private var messages: [Message] = [
        Message(text: "Have any questions about the service alerts? Feel free to ask the SubwayBot.", isUserMessage: false)
    ]
    @State private var userInput: String = ""
    @State private var isSending: Bool = false
    @State private var isLoadingAlerts: Bool = true // Track loading state for alerts

    var body: some View {
        VStack {
            if isLoadingAlerts {
                Text("Loading service alerts... Please wait.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Welcome Message
                Text("Ask the SubwayBot about service alerts or subway details!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }

            // Chat Messages with ScrollViewReader for Auto-Scrolling
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUserMessage {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .id(message.id) // Assign ID for scroll targeting
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    // Automatically scroll to the last message
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // User Input Field
            HStack {
                TextField("Type your question here...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
                .disabled(isSending || userInput.isEmpty || isLoadingAlerts)
            }
            .padding()
        }
        .navigationTitle("SubwayBot")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadServiceAlerts)
    }

    // Load Service Alerts
    private func loadServiceAlerts() {
        OpenAIServiceAlertsAPI.shared.fetchServiceAlerts { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    isLoadingAlerts = false
                case .failure(let error):
                    messages.append(
                        Message(
                            text: "Failed to load service alerts: \(error.localizedDescription)",
                            isUserMessage: false
                        )
                    )
                    isLoadingAlerts = false
                }
            }
        }
    }

    // Send Message Function
    private func sendMessage() {
        let userMessage = Message(text: userInput, isUserMessage: true)
        messages.append(userMessage)
        userInput = ""
        isSending = true

        // Fetch OpenAI response
        OpenAIServiceAlertsAPI.shared.sendUserQuery(query: userMessage.text) { response in
            DispatchQueue.main.async {
                let botMessage = Message(text: response, isUserMessage: false)
                messages.append(botMessage)
                isSending = false
            }
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}

#Preview {
    GeminiChatbotView()
}
