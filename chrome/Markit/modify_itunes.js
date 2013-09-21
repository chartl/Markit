// This function modifies behaviour of blue "View in iTunes" button on itunes.apple.com to store link
chrome.browserAction.onClicked.addListener(function(tab) {
  var Class = document.getElementsByClassName("action view-in-itunes");
  var id = document.getElementsByTagsName('a')[0];
  console.log("Class is " + Class);
  console.log("Class is " + id[0]);
})