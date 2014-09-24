/*
 L.BlazeIcon is based on the L.DivIcon, with a on change.
the blaze simply registers a hook to the div
rather then setting the innerHTML as the original did.
 */

L.BlazeIcon = L.Icon.extend({
    options: {
        iconSize: [12, 12], // also can be set through CSS
        /*
        iconAnchor: (Point)
        popupAnchor: (Point)
        html: (String)
        bgPos: (Point)
        */
        className: 'leaflet-div-icon',
        html: false
    },

    createIcon: function (oldIcon) {
        var div = (oldIcon && oldIcon.tagName === 'DIV') ? oldIcon : document.createElement('div'),
            options = this.options;

        /* change compared to DivIcon*/
        if(options.onCreate){
            options.onCreate(div)
        }

        if (options.bgPos) {
            div.style.backgroundPosition = (-options.bgPos.x) + 'px ' + (-options.bgPos.y) + 'px';
        }
        this._setIconStyles(div, 'icon');

        return div;
    },

    createShadow: function () {
        return null;
    }
});

L.blazeIcon = function (options) {
    return new L.BlazeIcon(options);
};