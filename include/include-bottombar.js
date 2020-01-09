const datetime = "10.01.20 @ 09:59 (+1100)";

// This pastes the fixed bar at the bottom of the page to the document.
// The datetime is retrieved upon executing the push script.
document.write(
	"<div id=\"bottom-bar\">This site was last updated: " + datetime + "</div>"
);

