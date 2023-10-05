import Foundation
import MessagingSDK
import MessagingAPI
import CommonUISDK
import ChatSDK
import ChatProvidersSDK

final class ZendeskMessaging {

    static let instance = ZendeskMessaging()

    #warning("Please provide Chat account key")
    let accountKey = ""

    // MARK: Configurations
    var messagingConfiguration: MessagingConfiguration {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Saturn Chat Bot"
        return messagingConfiguration
    }

    var chatConfiguration: ChatConfiguration {
        let formConfiguration = ChatFormConfiguration(name: .required,
                                                      email: .optional,
                                                      phoneNumber: .hidden,
                                                      department: .hidden)
        let chatConfiguration = ChatConfiguration()
        chatConfiguration.isAgentAvailabilityEnabled = true
        chatConfiguration.isPreChatFormEnabled = true
        chatConfiguration.preChatFormConfiguration = formConfiguration
        return chatConfiguration
    }

    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        return chatAPIConfig
    }

    // MARK: Chat
    func initialize() {
        setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: accountKey)
    }

    func setChatLogging(isEnabled: Bool, logLevel: LogLevel) {
        Logger.isEnabled = isEnabled
        Logger.defaultLevel = logLevel
    }

    // MARK: View Controller
    func buildMessagingViewController() throws -> UIViewController {
        CommonTheme.currentTheme.primaryColor = .cyan
        Chat.instance?.configuration = chatAPIConfig
        UINavigationBar.appearance().barTintColor = .cyan

        UINavigationBar.appearance().tintColor = .cyan
        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }
}

extension ZendeskMessaging {
    // MARK: Engines
    var engines: [Engine] {
        let engineTypes: [Engine.Type] = [ChatEngine.self]
        return engines(from: engineTypes)
    }

    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
        engineTypes.compactMap { type -> Engine? in
            switch type {
            case is ChatEngine.Type:
                return try? ChatEngine.engine()
            default:
                fatalError("Unhandled engine of type: \(type)")
            }
        }
    }
}
