import Foundation

struct SessionProposal: Codable, Equatable {
    let relays: [RelayProtocolOptions]
    let proposer: Participant
    let requiredNamespaces: [String: ProposalNamespace]
    let optionalNamespaces: [String: OptionalNamespace]?

    func publicRepresentation(pairingTopic: String) -> Session.Proposal {
        return Session.Proposal(
            id: proposer.publicKey,
            pairingTopic: pairingTopic,
            proposer: proposer.metadata,
            requiredNamespaces: requiredNamespaces,
            optionalNamespaces: optionalNamespaces,
            proposal: self
        )
    }
}
