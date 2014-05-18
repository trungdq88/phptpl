
var fs = require('fs');
var ncp = require('ncp').ncp;
	ncp.limit = 16;
var sys = require('sys')
var exec = require('child_process').exec;

//////// Utils
var utils = utils || {};
utils.deleteFolderRecursive = function(path) {
  if( fs.existsSync(path) ) {
    fs.readdirSync(path).forEach(function(file,index){
      var curPath = path + "/" + file;
      if(fs.lstatSync(curPath).isDirectory()) { // recurse
        utils.deleteFolderRecursive(curPath);
      } else { // delete file
        fs.unlinkSync(curPath);
      }
    });
    fs.rmdirSync(path);
  }
};
////////



var args = process.argv.splice(2);

var command = args[0];
var projectPath = args[1];

if (!projectPath) {
	console.log('Please provide project path.');
	return;
}

// Format path with ending slash
projectPath = projectPath.replace(/\/$/,'/') + '/';

var srcPath = projectPath + 'src';
var distPath = projectPath + 'dist';

switch(command) {
	case 'create': create(); break;
	case 'build' : build();  break;
}

function create() {

}

function build() {
	var configFile = projectPath + '.tpl';

	if (!fs.existsSync(configFile)) {
	    console.log(projectPath + ' is not PHPTPL project directory');
	    return;
	}

	console.log('--------------------------------------------------------------------------');
	console.log('Clear dist directory...');
	
	utils.deleteFolderRecursive(distPath);
	
	console.log('Clear dist directory done!');

	console.log('--------------------------------------------------------------------------');
	console.log('Copying resources...');

	ncp(srcPath, distPath, function (err) {
		if (err) {
			return console.error(err);
		}
		console.log('Deleting source files...!');

		fs.readdirSync(distPath).forEach(function(file,index){
			if (file.match(/\.php$/)) {
	        	fs.unlinkSync(distPath + "/" + file);	
			}
	    });

		console.log('--------------------------------------------------------------------------');
		console.log('Start build...');
		var child;
		fs.readdirSync(srcPath).forEach(function(file,index){
			if (file.match(/\.php$/) && !file.match(/\.inc\.php$/)) {
				var newName = file.replace(/php$/, 'html');
	        	console.log('Build... "' + srcPath + '/' + file + '" > "' + distPath + '/' + newName + '"');
	        	child = exec('php "' + srcPath + '/' + file + '" > "' + distPath + '/' + newName + '"');

			}
	    });

	    console.log('--------------------------------------------------------------------------');
		console.log('Complete!');
		
	});

}

