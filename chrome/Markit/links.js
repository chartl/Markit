// Markit

// Create contextual menu item for LINK and IMAGE context type.
var contexts = ["link","image"];
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

chrome.tabs.onUpdated.addListener(tabAuthListener);
var userFacebookID = null;
var userLoginCredentials = null;

FB_APP_ID = "731455460204887";
FB_SUCCESS_URL="https://www.facebook.com/connect/login_success.html";

function authenticateUserThroughFacebook() {
    // do something
    var facebook_auth_url = "https://www.facebook.com/dialog/oauth?client_id=" + FB_APP_ID + "&redirect_uri="+FB_SUCCESS_URL;
    console.log("Auth URL is:::: "+facebook_auth_url);
    window.open(facebook_auth_url);
    var cntr = 0;
}

function lookupFacebokID(token) {
  // todo -- look up the username of the individual.
  // todo -- robustness to when they don't have the app added or the correct permissions.
  // return token;
  return "ibeshim";
}

function useFacebookAuth() {
    return false;
}

function authenticateUser() {
    if ( useFacebookAuth() ) {
        authenticateUserThroughFacebook();
    } else {
        popupAuthentication();
    }
}

function secureCredentials(uname,passwd) {
    // ideally a cryptographic hash would sit here like sha2 to take
    // these data and use as the 'server side' username
//    salted = '####' + uname + '####' + passwd + '####';
    return uname + passwd;
}

function popupAuthentication() {
    // not clear what to do
    userLoginCredentials = secureCredentials("chris","h477k");
}

function tabAuthListener(tabInfo,changeInfo,tabObj) {
    var url = changeInfo.url;
    if ( url && url.indexOf(FB_SUCCESS_URL)==0) {
        console.log("URL is: "+url);
        var auth_token =  url.split('=')[1].split('#')[0];
        console.log("Auth token is :::: " + auth_token);
        userFacebookID = lookupFacebokID(auth_token);
        console.log("ID token is :::: "+userFacebookID);
    }

    return "";
}

function logClickItem(info,tab) {
    console.log("item " + info.menuItemId + " was clicked");
    console.log("info: " + JSON.stringify(info));
    console.log("tab: " + JSON.stringify(tab));
    // Code created by me. Trying to get destination URL out.
    console.log("Destination URL: " + info.linkUrl);
}

function getApplicationName(itunesURL) {
    // todo -- find some way to retrive the app name given this url
    return "-";
}

// A generic onclick callback function.
// This function returns the link.
function genericOnClick(info, tab) {
  logClickItem(info,tab);

  saveLink(info.linkUrl);
  validateLink(info.linkUrl);
  var appName = getApplicationName(info.linkURL);

  if ( ! userLoggedIn() ) {
      authenticateUser();
  }
  if ( ! userLoggedIn() ) {
      return; // todo -- this is really a timing issue, the authentication happens but the tab listener isn't processed until after genericOnClick finishes.
      // todo -- maybe this can't happen in an online fashion?
  }
  var credentials;
  if ( userFacebookID != null ) {
      credentials = userFacebookID;
  } else {
      credentials = userLoginCredentials;
  }
  var more = [credentials,appName,info.linkUrl]; // todo -- enable user to use a Markit account if don't want to use FB
  sendLink(more);
  console.log("________________________________________________________________");
  console.log("________________________________________________________________");
}

function userLoggedIn()  {
    return userFacebookID != null || userLoginCredentials != null;
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

// Send the link to the server
function sendLink(more) {
  send_link = new XMLHttpRequest ();
  send_link.open("POST","http://ec2-54-200-56-45.us-west-2.compute.amazonaws.com:80");
  send_link.onload = function () {
    console.log("Loaded! Fuck Yeah!");
  };
  send_link.send(more);
  console.log("Should have sent the SHIT");
}

    // ec2-54-200-16-176.us-west-2.compute.amazonaws.com - Ilias
    // ec2-54-200-56-45.us-west-2.compute.amazonaws.com - Chris

// Modifies itunes.apple.com behavior
// chrome.browserAction.onClicked.addListener(function(tab) {
//       chrome.tabs.executeScript(null, {Code:
//          document.onclick = function() {
//            var Class = document.getElementsByClassName("action view-in-itunes");
//            var id = document.getElementsByTagsName('a')[0];
//            console.log("Class is " + Class);
//            console.log("Class is " + id[0]);
//        }
//        })
//    })
// This function checks if the link already exists in storage

// web-storefront-preview.css
// #main #content #title a.view-in-itunes span,#main #content #left-stack a.view-in-itunes span{display:block;width:106px;height:23px;margin:0;text-indent:-9999px;background:url(web-storefront/images/viewinitunes_en.png) 0 0 no-repeat}

// need to change the image and the destination URL