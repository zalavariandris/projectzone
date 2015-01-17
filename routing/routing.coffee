Router.map ->
    this.route 'maponly',
        path: "/map"
        layoutTemplate: "layout"
        template: "projectZoneLogo"

    this.route 'originalSite',
        path: "/"
        layoutTemplate: "layout"
        template: "originalSite"

    this.route 'login',
        path: "/login"
        layoutTemplate: "layout"
        template: "projectZoneLogo"
        yieldTemplates:
            'login': to: "modal"