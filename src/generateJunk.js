import makeid from './generateId';
import templates from './templates';

function GenJunkCode() {
    var result = '';
    
    function generateCode() {
        return makeid(Math.floor(Math.random() * (75 - 50)) + 50);
    };

    for ( var i = 0; i < Math.floor(Math.random() * (75 - 50)) + 50; i++ ) {
        result += templates.junkFor.replace(/randomString/g, '"' + generateCode() + '"').replace(/randomMax/g, Math.floor(Math.random() * (75 - 50)) + 50) + '\n';
    }
    return result;
}

export default GenJunkCode;