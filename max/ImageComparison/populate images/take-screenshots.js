function GetConfig() {
	var fs = require('fs');

	var content = fs.read('populate images\\config.json');
	return JSON.parse(content);
}

function InitPage() {
	var page = require('webpage').create();
	page.viewportSize = {
		width: 1920,
		height: 1200
	};
	//page.zoomFactor = 1;
	return page;
}

function Init() {
	//page = InitPage();
	runConfig = GetConfig();
	renderedPageCount = 0;
}

function exitWhenDone(){
	console.log(renderedPageCount + " == " + 2*runConfig.urls.length);
	if (renderedPageCount == 2*runConfig.urls.length){
		phantom.exit();
	}
}

function renderPage2(fullOutputFileName, url) {
	console.log(url);
	console.log("fullOutputFileName: " + fullOutputFileName);
	var newPage = InitPage();
	
	newPage.open(url, function (status) {
				//console.log("first"  + newPage.url, url);
		if (status !== 'success') {
			console.log('unable to load the address!');
			phantom.exit();
		} else {
			window.setTimeout(function () {
				console.log(newPage.url, url);
				newPage.render(fullOutputFileName, {
					format: 'png',
					quality: '100'
				});
				renderedPageCount++;
				console.log(runConfig.baseUrl + url + " - done.");
			}, 3000);
		}		
	});
}

Init();

console.log("Running tests againts " + runConfig.baseUrl + " and " + runConfig.targetUrl);


for (var urlIndex = 0; urlIndex < runConfig.urls.length; urlIndex++) {
	renderPage2('output/baseline/' + urlIndex + '.png', runConfig.baselineUrl + runConfig.urls[urlIndex]);
	renderPage2('output/current/' + urlIndex + '.png', runConfig.currentUrl + runConfig.urls[urlIndex]);
}

window.setInterval(function () {
	exitWhenDone();
}, 1000);