function makeid(length) {
    var result = String.fromCharCode(Math.floor(Math.random() * (122 - 97)) + 97); // random a-z, so we don't get an error from Lua that there's some unfinished number
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

export default makeid;