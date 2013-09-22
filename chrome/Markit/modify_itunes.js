// ==UserScript==
// @name     _Add a simple button to a page
// @include  https://itunes.apple.com/*
// @require  http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js
// @grant    GM_addStyle
// ==/UserScript==
/*- The @grant directive is needed to work around a design change
    introduced in GM 1.0.   It restores the sandbox.
*/

//chrome.browserAction.onClicked.addListener(function(tab) {
//  var Class = document.getElementsByClassName("action view-in-itunes");
//  var id = document.getElementsByTagsName('a')[0];
//  console.log("Class is " + Class);
//  console.log("Class is " + id[0]);
//})

// This function adds button to the page

var MarkItButton  = $('.action view-in-itunes');

//-- Add button.
MarkItButton.parent ().after (
    '<a href="#" id="MarkItButton">MarkItButton Saves Link</a>'
);

//-- Activate the button.
$("#MarkItButton").click ( function () {
    console.log ("FUCK YEA!");
} );
