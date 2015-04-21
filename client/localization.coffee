Languages = {}

Languages.en = {
    requestInvitationHeader: "Request invitation"
    requestInvitationBody: "<p>This is a closed beta preview of ProjectZone.</p>
        <p>Please request an invitation by filling out the form below to add your own project spaces to the map!</p>
        <p>We'll process your request as soon as possible, and neccessary information will be sent to your emailbox.</p>"
    requestInvitationSubmit: "request invitation"

    name: 'name'
    select: "please select"
}

Languages.hu = {
    add: "hozzáad"
    invites: "meghívások"
    login: "belépés"
    request_invite: "kérj meghívót"
    logout: "kijelentkezem"

    requestInvitationHeader: "Meghívó"
    requestInvitationBody: "<p>Ez a Projectzone tesztüzeme.</p>
    <p>Ha szeretnéd felteni saját project space-det a térképre, küld el nekünk emailcímedet az alábbi mezőben és máris megy a meghívó!</p>
    "
    requestInvitationSubmit: "kérek egy meghívót"

    name: 'név'
    select: "válassz"
    type: "típus"
    start: "indult"
    closed: "bezárt"
    website: 'honlap'



    update: "frissítés"
    cancel: "mégse"
    remove: "törlés"
    more: "tovább"

    invites: "meghívók"
    admins: "admins"

    owner: "gazdi"
    edit: "szerkeszt"
    can_edit: "szerkesztők"
}

Session.setDefault('language', 'hu');

Template.registerHelper 'localize', (key)->
    language = Session.get('language')

    return Languages[language][key] or ""+key+""