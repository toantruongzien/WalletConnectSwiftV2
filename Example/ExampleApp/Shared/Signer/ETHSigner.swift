import Foundation
import Commons
import Web3

struct ETHSigner {

    private init() {}

    static var address: String {
        return privateKey.address.hex(eip55: true)
    }

    private static let privateKey: EthereumPrivateKey = {
        return try! EthereumPrivateKey(hexPrivateKey: "0xe56da0e170b5e09a8bb8f1b693392c7d56c3739a9c75740fbc558a2877868540")
    }()

    static func personalSign(_ params: AnyCodable) -> AnyCodable {
        let params = try! params.get([String].self)
        let messageToSign = params[0]
        let dataToHash = dataToHash(messageToSign)
        let (v, r, s) = try! privateKey.sign(message: .init(hex: dataToHash.toHexString()))
        let result = "0x" + r.toHexString() + s.toHexString() + String(v + 27, radix: 16)
        return AnyCodable(result)
    }

    static func signTypedData(_ params: AnyCodable) -> AnyCodable {
        let result = "0x4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b915621c"
        return AnyCodable(result)
    }

    static func sendTransaction(_ params: AnyCodable) -> AnyCodable {
        let params = try! params.get([EthereumTransaction].self)
        var transaction = params[0]
        transaction.gas = EthereumQuantity(quantity: BigUInt("1234"))
        print(transaction.description)
        let signedTx = try! transaction.sign(with: self.privateKey, chainId: 4)
        let (r, s, v) = (signedTx.r, signedTx.s, signedTx.v)
        let result = r.hex() + s.hex().dropFirst(2) + String(v.quantity, radix: 16)
        return AnyCodable(result)
    }

    private static func dataToHash(_ message: String) -> Bytes {
        let prefix = "\u{19}Ethereum Signed Message:\n"
        let messageData = Data(hex: message)
        let prefixData = (prefix + String(messageData.count)).data(using: .utf8)!
        let prefixedMessageData = prefixData + messageData
        let dataToHash: Bytes = .init(hex: prefixedMessageData.toHexString())
        return dataToHash
    }
}
