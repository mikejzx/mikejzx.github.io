
// Downloads the e-mail address from file created on the fly.
// https://stackoverflow.com/questions/3665115/how-to-create-a-file-in-memory-for-user-to-download-but-not-through-server
function download_email(filename, content_base64)
{
	/* New method */
	var tab = window.open("about:blank", "_blank");
	tab.document.write(
		"<body style=\"font-family: monospace; font-size: 16px; background: #000; color: #fff\">" +
		"<span>My e-mail address:</span><br><br>" +
		"<a style=\"color: #0af;\" href=\"mailto:" + atob(content_base64) + "?subject=Hello!\">" + atob(content_base64) + "</a>" +
		"<br><br><span style=\"color: #888;\">Generated using JavaScript to prevent web-scrapers getting my e-mail!</span>" +
		"</body>"
	);
	tab.document.close();
}
