public struct ValidateStatus201BodyStrategy: ResponseBodyDecodingStrategy {
    public static func allowsEmptyContent(for _: Int) -> Bool {
        false
    }

    public static func validate(statusCode: Int) -> Bool {
        statusCode == HTTPStatusCode.created.rawValue
    }
}
