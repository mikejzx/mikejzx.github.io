
// Downloads the e-mail address from file created on the fly.
// https://stackoverflow.com/questions/3665115/how-to-create-a-file-in-memory-for-user-to-download-but-not-through-server
function download_email(filename, content_base64)
{
	var el = document.createElement("a");
	el.setAttribute("href", "data:text/plain;charset=utf-8," + encodeURIComponent("My e-mail address:\n\n" + atob(content_base64) + "\n\n\nThis file is generated on the fly using JavaScript, to prevent bots from giving my e-mail address to spammers."));
	el.setAttribute("target", "_blank");
	
	el.style.display = "none";
	document.body.appendChild(el);
	el.click();
	document.body.removeChild(el);
}
