local Translations = {
    interact = "Suhtle elanikuga",
    reject = "Loobusid",
    time_waste = "Raiskasid piisavalt aega!",
    no_item = "Sul pole piisavalt nõutud eset",
    sell_success = "Müümine õnnestus",
    selltitle = "Müü pakutud ese ",
    buyer = "Ostja",
    menutitle = "Müümine",
    declinetitle = "Loobu müügist",
    spoked = "Juba kauplesid temaga!",
    sell_last = "Müüsid viimase koguse ära!",
    needs = "%dx of %s for %d$",
    buyer_ready = "Klient on valmis!"
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
