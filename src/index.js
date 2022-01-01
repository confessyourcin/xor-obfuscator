import templates from './templates';
import {readAsByteArray} from './LocalFileLoader';
import luaSimpleXorEncrypt from './LuaSimpleXorEncrypt';
import {saveAs} from 'file-saver';
import makeid from './generateId';

let elFile = document.getElementById('file');
let elEncrypt = document.getElementById('encrypt');
let elFileName = document.getElementById('file-name');

elFile.addEventListener('change', function () {
  if (elFile.files[0]) {
    elFileName.textContent = elFile.files[0].name;
  }
});

elEncrypt.addEventListener('click', function () {
  if (elFile.files[0]) {
    console.log(elFile.files[0].responseText)
    readAsByteArray(elFile.files[0], function (bytes, file) {
      function encryptLua(code) {
        var encrypted = '';
        for (let i = 0; i < code.length; i++) {
          encrypted += '\\' + code.charCodeAt(i);
        }
        return 'load("' + encrypted + '")()'
      }
      
      var latestGlobal = makeid(Math.floor(Math.random() * (75 - 50)) + 50);
      var hideGlobal = latestGlobal + '=_G;'; 

      var encrypted = '';
      for (let i = 0; i < Math.floor(Math.random() * (35 - 25)) + 25; i++) {
        let result = luaSimpleXorEncrypt([].slice.call(new TextEncoder("utf-8").encode(templates.randomLuaCode)), makeid(25), latestGlobal, hideGlobal)
        encrypted += result.encrypted + ';';
        latestGlobal = result.latestglobal;
        hideGlobal = makeid(Math.floor(Math.random() * (75 - 50)) + 50) + '=' + latestGlobal + ';';
      }

      let result = luaSimpleXorEncrypt(bytes, makeid(25), latestGlobal, hideGlobal);
      encrypted += result.encrypted + ';';
      latestGlobal = result.latestglobal;
      hideGlobal = makeid(Math.floor(Math.random() * (75 - 50)) + 50) + '=' + latestGlobal + ';';

      for (let i = 0; i < Math.floor(Math.random() * (35 - 25)) + 25; i++) {
        let result = luaSimpleXorEncrypt([].slice.call(new TextEncoder("utf-8").encode(templates.randomLuaCode)), makeid(25), latestGlobal, hideGlobal)
        encrypted += result.encrypted + ';';
        latestGlobal = result.latestglobal;
        hideGlobal = makeid(Math.floor(Math.random() * (75 - 50)) + 50) + '=' + latestGlobal + ';';
      }

      if ( document.getElementById('bytecode').checked == true ) {
        encrypted = encryptLua(encrypted);
      }

      let blob = new Blob([encrypted], {type: 'application/octet-stream'});
      saveAs(blob, file.name);
    });
  }
});
