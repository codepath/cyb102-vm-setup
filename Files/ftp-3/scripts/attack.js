/**
 * Author: Liang Gong
 * Modified by: Andrew Burke (CodePath)
 * Modified by: Sar Champagne Bielert (CodePath)
 */
(function() {
    var http = require('http');
    var colors = require('colors');
    var content;
    if (process.argv.length - 2 < 1) {
	console.log("Please include a target url argument.");
	process.exit();
    }
    var url = process.argv[2]; //'http://localhost:8888/random1.txt';

    console.log('\t[' + 'directory traversal attack'.green + ']: ' + url);

    var content = '';

    http.get(url, (res) => {
        res.on('data', (chunk) => {
            content += chunk.toString('utf-8');
        });
        res.on('end', () => {
            console.log('\t[' + 'directory traversal request response'.green + ']: ' + content.toString('utf-8').red);
        });
    });
})();
