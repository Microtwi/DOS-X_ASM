// Variables
let currentTarget = null;
let currentMouseTarget = null;
let currentTargetType = null;
let currentMouseTargetType = null;

// Context Menu Initialization
function initializedContextMenu() {

    var AMBER = 'amber', GREEN = 'green';
    var key = 'docs-theme';
    var saved = localStorage.getItem(key);
    var root = document.documentElement;
    if (saved === AMBER || saved === GREEN) { root.setAttribute('data-theme', saved); }
    var btn = document.getElementById('themeToggle');
    if (btn) {
        btn.addEventListener('click', function () {
            var next = (root.getAttribute('data-theme') === GREEN) ? AMBER : GREEN;
            root.setAttribute('data-theme', next);
            try { localStorage.setItem(key, next); } catch (e) { }
        });
    }

    // Get Elements
    document.addEventListener('mousemove', event => {
        const x = event.clientX;
        const y = event.clientY;
        const element = document.elementFromPoint(x, y);

        if (element == null)
            return;

        if (element.tagName === 'A') {
            const link = element.getAttribute('href');
            currentMouseTarget = link;
            currentMouseTargetType = "text";
        }
        else if (element.tagName === 'IMG') {
            const src = element.getAttribute('src');
            currentMouseTarget = src;
            currentMouseTargetType = "image";
        }
        else if (element.tagName === 'VIDEO') {
            const src = element.getAttribute('src');
            currentMouseTarget = src;
            currentMouseTargetType = "video";
        }
        else if (element.id === 'context-menu') { }
        else if (element.classList.contains('menuLinkLongAlt')) { }
        else if (element.classList.contains('line')) { }
        else if (element.tagName === 'BUTTON') {
            currentMouseTarget = event;
            currentMouseTargetType = "button";
        }
        else {
            currentBtnEvent = null;
            currentMouseTarget = null;
            currentMouseTargetType = null;
        }
    });

    document.addEventListener("scroll", event => {
        currentTarget = null;
        currentTargetType = null;
        closeImage();
    });


    document.addEventListener("click", e => {
        const bg = document.querySelector(".fullscreenImageBG");

        // OPEN fullscreen
        if (e.target.tagName === "IMG" && !e.target.classList.contains("fullscreenImgContext")) {

            bg.innerHTML = `<img src="${e.target.src}" 
                             class="fullscreenImage fullscreenImgContext">`;

            bg.classList.add("active");
            return;
        }

        // CLOSE fullscreen if clicking background or fullscreen image
        if (e.target === bg || e.target.classList.contains("fullscreenImgContext")) {
            closeImage();
        }
    });

}

let winWidth = window.innerWidth;
let winHeight = window.innerHeight;

function zoomImage() {
    if (currentTargetType == "image") {
        var div = document.querySelector(".fullscreenImageBG");
        div.classList.add("active");

        var oldDiv = document.querySelector("#fullscreenImgContext");

        if (oldDiv != null) {
            oldDiv.remove();
        }

        let newWinWidth = window.innerWidth;
        let newWinHeight = window.innerHeight;
        if ((newWinWidth - winWidth > 150 || newWinWidth - winWidth < -150) && (newWinHeight - winHeight > 50 || newWinHeight - winHeight < -50)) {
            winWidth = window.innerWidth;
            winHeight = window.innerHeight;
        }

        div.insertAdjacentHTML("beforeend", '<img src="' + currentTarget + '"width="' + winWidth / 1.3 + 'px" class="fullscreenImage" id="fullscreenImgContext"></img>');

        var newDiv = document.querySelector("#fullscreenImgContext");
        newDiv?.addEventListener('click', () => {
            closeImage();
        })

        newDiv.style.top = ((winHeight - newDiv.offsetHeight) / 2) + "px";
        newDiv.style.left = ((winWidth - newDiv.offsetWidth) / 2) + "px";
        // document.body.style.overflow = 'hidden';
    }
}

function closeImage() {
    document.body.style.overflow = '';

    var div = document.querySelector(".fullscreenImageBG");
    div.classList.remove("active");

    var oldDiv = document.querySelector("#fullscreenImgContext");

    if (oldDiv != null) {
        oldDiv.remove();
    }
}