
@propertyWrapper
public struct ResponseBodyWrapper<Body: Decodable, DecodingStrategy: ResponseBodyDecodingStrategy> {

    public var wrappedValue: Body?

    public init() {
        wrappedValue = nil
    }

    public init(wrappedValue: Body?) {
        self.wrappedValue = wrappedValue
    }
}

extension ResponseBodyWrapper: Decodable {

    public init(from decoder: Decoder) throws {
        guard let responseDecoder = decoder as? ResponseDecoding else {
            wrappedValue = try Body(from: decoder)
            return
        }
        guard HTTPStatusCode.ok ..< HTTPStatusCode.multipleChoices ~= responseDecoder.response.statusCode else {
            wrappedValue = nil
            return
        }
        DecodingStrategy.statusCode = responseDecoder.response.statusCode

        if DecodingStrategy.allowsEmptyBody, responseDecoder.data.isEmpty {
            wrappedValue = nil
            return
        }
        wrappedValue = try responseDecoder.decodeBody(to: Body.self)
    }
}
