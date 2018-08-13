
var inter = setInterval(tick, (1.0 / 60.0) * 20.0);

function stopTimer() {
    clearInterval(inter);
}

$(document).ready(function () {
    var fr = new Date(Date.now());
    var to = new Date(fr.getUTCFullYear(), 11, 31, 24, 59, 59, 0);
    var secDiff = Math.abs(to.getTime() - fr.getTime()) / 1000;
    var wholeDays = Math.floor(secDiff / 86400);

    var col = "turquoise";
    if (wholeDays < 7) {
        col = "red";
    }

    $("#countdowndays").css("color", col);
    $("#countdownhours").css("color", col);
    $("#countdownmins").css("color", col);
    $("#countdownsecs").css("color", col);
});

function tick() {
    var fr = new Date(Date.now());
    var to = new Date(fr.getUTCFullYear(), 11, 31, 24, 59, 59, 0);

    var doyFr = getDayOfYear(fr);
    var doyTo = getDayOfYear(to);
    var dayDiff = doyTo - doyFr;

    var secDiff = Math.abs(to.getTime() - fr.getTime()) / 1000;
    var wholeDays = Math.floor(secDiff / 86400);
    secDiff -= wholeDays * 86400;

    // Find hours:
    var hours = Math.floor(secDiff / 3600) % 24;
    secDiff -= hours * 3600;

    // Find Minutes
    var mins = Math.floor(secDiff / 60) % 60;
    secDiff -= mins * 60;

    var hourFr = fr.getUTCHours();
    var hourTo = 23;
    var hoursDiff = hourTo - hourFr;

    //document.getElementById("countdownthing").innerHTML = "Time left till the end of this Year: " + dayDiff + " days, " + hours + " hours, " + mins + " Minutes, and " + padZeros(secDiff.toString(), 16) + " Seconds.";
    document.getElementById("countdowndays").innerHTML = wholeDays;
    document.getElementById("countdownhours").innerHTML = hours;
    document.getElementById("countdownmins").innerHTML = mins;
    var baseSecs = padZeros(secDiff.toString(), 18);
    var leftSecs = baseSecs.substring(0, 6);
    var rightSecs = baseSecs.substring(12, 17);
    document.getElementById("countdownsecs").innerHTML = leftSecs + rightSecs;
}

function isLeapYear(date) {
    var year = date.getFullYear();
    if ((year & 3) != 0) { return false; }
    return ((year % 100) != 0 || (year % 400) == 0);
}

function getDayOfYear (date) {
    var dayCount = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    var mn = date.getMonth();
    var dn = date.getDate();
    var dayOfYear = dayCount[mn] + dn;
    if (mn > 1 && isLeapYear(date)) { dayOfYear++; }
    return dayOfYear;
}

function padZeros(str, len) {
    var n = str;
    while (n.length < len) {
        n += '0';
    }
    return n;
}