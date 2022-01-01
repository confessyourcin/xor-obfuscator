import utf8 from 'utf8';
import luamin from 'luamin';
import simpleXorEncrypt from './SimpleXorEncrypt';
import shuffleWithKey from './ShuffleWithKey';
import templates from './templates';
import makeid from './generateId';
import luaparse from 'luaparse';
var converter = require('hex2dec');


function luaSimpleXorEncrypt(bytes, key, latestGlobal, hideGlobal) {
  function randomInt(length) {
    return Math.floor(Math.pow(10, length - 1) + Math.random() * parseInt(Math.pow(10, length - 1).toString().replace('1', '9')))
  }

  var Key53 = randomInt(16);
  var Key14 = randomInt(4);

  var inv256 = {};

  function encode(str) {
    function localEncode() {
      for (let i = 0; i < 128; i++) {
        var inv = -1
        while(inv * (2 * i + 1) % 256 != 1) {
          inv += 2;
          inv256[i] = inv;
        }
      };
      
      var K = Key53;
      var F = Key14 + 16384;
      var result = ''
      
      for (var i = 0; i < str.length; i++) {
        var L = K % 274877906944;
        var H = (K - L) / 274877906944;
        var M = H % 128;
        var c = (str.charCodeAt(i) * inv256[M] - (H - M) / 128) % 256;
        K = L * F + H + c + str.charCodeAt(i);
        var encoded = converter.decToHex(Math.abs(c).toString(), {prefix: false}).toUpperCase();
        if (encoded.length == 1) {
          result += '0' + encoded;
        } else {
          result += encoded;
        }
        // if ( (+c).toString(16).toUpperCase().length == 1 ) {
        //   result += '0' + (+c).toString(16).toUpperCase();
        // } else {
        //   result += (+c).toString(16).toUpperCase()
        // }
      }

      return result;
    }

    var generated = false;
    var encoded = '';
    while (!generated) {
      var res = localEncode();
      if ( (res.match(/-/g) || []).length == 0 ) {
        encoded = res;
        generated = true
      } else {
        Key53 = randomInt(16);
        Key14 = randomInt(4);
      }
    }

    return encoded;
  }

  function generateCode() {
    return makeid(Math.floor(Math.random() * (75 - 50)) + 50);
  };

  let randomLoad = generateCode();

  let encrypted = simpleXorEncrypt(bytes, utf8.encode(key));
  let shuffled = shuffleWithKey(encrypted, key);

  let amountToObfuscate = Math.floor(Math.random() * (15 - 5)) + 5;
  for ( let i = 0; i < amountToObfuscate; i++ ) {
    let randomized = generateCode();
    hideGlobal += randomized + '=' + latestGlobal + ';';
    latestGlobal = randomized;
  }

  let code = hideGlobal
    + templates.decoder.replace(/cb/g, generateCode())
    + templates.load.replace(/globalload/g, randomLoad).replace("key", '"' + key + '"').replace("bytecode", shuffled.join(','))

  var generateCodes = [
    'getCode', 
    'returnedCode', 
    'resultDataBytes', 
    'resultDecoded', 
    'resultStringBytes', 
    'bytesToStringResult', 
    'hideBytesThingy', 
    'bytesToString', 
    'decode', 
    'getDataBytes', 
    'bxor', 
    'decryptString', 
    'globalChar', 
    'globalString',
    'disablePrintFunction',
    'disablePrint'
  ]
  for (var k in generateCodes) {
    code = code.split(generateCodes[k]).join(generateCode());
  }
  code = code.replace(/loadGlobal/g, latestGlobal);
  code = code.replace(/Key14/g, Key14.toString());
  code = code.replace(/Key53/g, Key53.toString());
  
  var needsEncode = ['string', 'char', 'load', 'print']
  for (var k in needsEncode) {
    for (var i = 0; i < needsEncode[k].length; i++) {
      code = code.split(needsEncode[k] + (i + 1)).join(encode(needsEncode[k].charAt(i)));
    }
  }

  code = code.replace(/globalPrint/g, encode('print'));
  code = code.replace(/getParamsFunction/g, generateCode());
  code = code.replace(/resultParams/g, generateCode())
  code = code.replace(/currentByte/g, generateCode());

  return {encrypted:luamin.minify(code), hideglobal:hideGlobal, latestglobal:latestGlobal};
}

export default luaSimpleXorEncrypt;