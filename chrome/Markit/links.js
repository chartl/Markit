// Markit

// Need AWS SimpleDB Connection


// Create contextual menu item for LINK context type.
var contexts = ["link"];
for (var i = 0; i < contexts.length; i++) {
  var context = contexts[i];
  var title = "Test '" + context + "' menu item";
  var id = chrome.contextMenus.create({
    "title": title, 
    "contexts":[context],
    "onclick": genericOnClick
    });
  console.log("'" + context + "' item: " + id);
}

// A generic onclick callback function.
// This function returns the link.
function genericOnClick(info, tab) {
  console.log("item " + info.menuItemId + " was clicked");
  console.log("info: " + JSON.stringify(info));
  console.log("tab: " + JSON.stringify(tab));
  // Code created by me. Trying to get destination URL out.
  console.log("Destination URL: " + info.linkUrl);
  saveLink(info.linkUrl);
  validateLink(info.linkUrl);
  console.log("________________________________________________________________");
  console.log("________________________________________________________________");
}

// Array for saving links returned by genericOnClick function
var links = [];
function saveLink (linkUrl) {
  links.push(linkUrl);
  
  //Print out all links saved
  for (var i = 0; i < links.length; i++) {
  var y = i + 1;
  console.log(y + ". " + links[i]);
  }
}

// Conditions under which link is saved
// 1. iTunes link pattern:
//    a. https://itunes.apple.com - DONE
//    b. http://itunes.apple.com - DONE
// 2. Calls up iTunes program.
// 3. Calls up .js function that takes user to https://itunes.apple.com
// 4. Calls up .js function that takes user to iTunes store
// 5. When on itunes.apple.com, clicking on blue "View in iTunes" button will save page's url.
// 6. When it is an affiliate link - DONE

// This function validates if it is an app itunes link
function validateLink (link) {
//  is_itunes = link.substring(0,24);
//  console.log ("Substring is " + is_itunes);
  if(link.substring(0,23) === 'http://itunes.apple.com') {
    console.log ("Link is valid");
  } 
    else if (link.substring(0,24) === 'https://itunes.apple.com') {
    console.log ("Link is valid");
  } 
    else if (link.substring(0,24) === 'https://itunes.apple.com') {
    console.log ("Link is valid");
  } 
    else if (link.substring(0,29) === 'https://click.linksynergy.com') {
    console.log ("Link is valid");
    // Need to pull out itunes link
  }
    else if (link.substring(0,28) === 'http://click.linksynergy.com') {
    console.log ("Link is valid");
    // Need to pull out itunes link
  }
    else {
    console.log ("Link is NOT valid");
  }
}

// This function checks if the link already exists in storage






// Modify itunes.apple.com

// web-storefront-preview.css
// #main #content #title a.view-in-itunes span,#main #content #left-stack a.view-in-itunes span{display:block;width:106px;height:23px;margin:0;text-indent:-9999px;background:url(web-storefront/images/viewinitunes_en.png) 0 0 no-repeat}

// need to change the image and the destination URL

