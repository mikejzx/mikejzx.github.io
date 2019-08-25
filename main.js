
// Adjust parallax img based off scroll amount.
function scrolled_callback() {
    var scroll_amount = window.pageYOffset / 2;
    var y = "calc(60% + " + scroll_amount + "px)";

    document.getElementById("bg-main").setAttribute("style", 
        "background-position: 50% " + y + " !important;");
}