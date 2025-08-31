import Sentry

extension BreadcrumbTracker {
    public static let live = BreadcrumbTracker { crumb in
        SentrySDK.addBreadcrumb(crumb)
    }
}
