// Initialisation code here
var cvs = document.getElementById("gameCanvas");
var ctx = cvs.getContext("2d");
setInterval(tick, 16.66666); // Run at 60fps

var middle = (cvs.height / 2) - 16;
var player = new component(32, 32, "cyan", 10, middle);

var jumpheight = 25.0;
var jumpspeed = 1;
var jumped = false;
var jumping = false;

function component(width, height, color, x, y) {
    this.width = width; this.height = height; this.x = x; this.y = y;
    this.update = function () {
        ctx.fillStyle = color;
        ctx.fillRect(this.x, this.y, this.width, this.height);
    }
}

function tick() {
    // Clear last frame
    ctx.clearRect(0, 0, cvs.width, cvs.height);

    // Draw background
    ctx.fillStyle = "#555";
    ctx.fillRect(0, 0, cvs.width, cvs.height);

    if (!jumping) {
        if (player.y < middle) {
            jumped = true;
            player.y += 1;
        }
        else {
            jumped = false;
        }
    }
    else {
        if (player.y > middle - jumpheight) {
            player.y -= jumpspeed;

            if (player.y <= middle - jumpheight) {
                player.y = middle - jumpheight;
            }
        }
        else {
            jumping = false;
        }
    }

    // Draw player
    player.update();
}

// Key down events
window.addEventListener("keydown", function (event) {
    if (event.defaultPrevented || jumped || jumping) {
        return;
    }

    switch (event.key) {
        case "ArrowUp":
            player.y = middle - jumpheight;
            jumping = true;
            break;
        default: return;
    }

    // Cancel the default action to avoid it being handled twice
    event.preventDefault();
}, true);