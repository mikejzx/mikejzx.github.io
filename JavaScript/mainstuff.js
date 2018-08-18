function mainMenu() {
    $("#nav ul").css({ display: "none" });
    $("#nav li").hover(
        function () {
            $(this).find('ul:first').css({ visibility: "visible", display: "none" }).show(400);
        },
        function () {
            $(this).find('ul:first').css({ visibility: "hidden" });
        }
    );
}

function perspectiveBg() {
    var movementStrength = 25;
    var height = movementStrength / $(window).height();
    var width = movementStrength / $(window).width();
    $("body").mousemove(function (e) {
        var pageX = e.pageX - ($(window).width() / 2);
        var pageY = e.pageY - ($(window).height() / 2);

        // Clamp values
        pageY = clamp(pageY, -430, 430);

        var newvalueX = width * pageX * -1 - 25;
        var newvalueY = height * pageY * 1 - 50;

        // Debug values:
        //document.getElementById("debugthing").innerHTML = "X: " + pageX + ", Y: " + pageY;

        // Move bg
        var str = newvalueX + "px     " + (newvalueY + 37) + "px";
        $('.imageContainer').css("background-position", str);
        $('.imageContainerDl').css("background-position", str);

        // Move nav-bar img (the offsets are pretty approximate)
        var str2 = (newvalueX - 20) + "px     " + (newvalueY - 57) + "px";
        $('#banner').css("background-position", str2);
        $('#bannerDl').css("background-position", str2);
    });
}

function clamp(val, mi, ma) {
    if (val > ma) { return ma; }
    if (val < mi) { return mi; }
    return val;
}

// Unused
function prepareCursorThing() {
    $("#nav li").mousemove(function (e) {
        var x = e.pageX - e.target.offsetLeft - 100;
        var y = e.pageY - e.target.offsetTop - 100;

        e.target.style.setProperty('--x', x + 'px');
        e.target.style.setProperty('--y', y + 'px');
    });
}

$(document).ready(function () {
    mainMenu();
    perspectiveBg();
    //prepareCursorThing();
});