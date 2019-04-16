/*
 * Apperle | Responsive App Landing Page.
 * Author: perleTheme Template
 * Copyright: 2017;
 * This is a premium product available exclusively here : https://themeforest.net/user/perletheme
 */
(function ($) {
    'use strict';
    /*----- Background Video Setup -----*/

    var $videoBackground = $('.video');
    if($videoBackground.length){
        $videoBackground.YTPlayer({
            videoId: 'jUvD80mNKBM',
            fitToBackground: false,
            mute: true,
            pauseOnScroll: false,
            playerVars: {
                modestbranding: 0,
                autoplay: 1,
                showinfo: 0,
                wmode: 'transparent',
                branding: 0,
                rel: 0,
                autohide: 0,
                origin: window.location.origin
            }
        });
    }

    /*----- Parallax Background Setup -----*/
    var scene = document.getElementById('scene');
        if(scene) {
            var parallax = new Parallax(scene, {
                pointerEvents: true
            });
        }


    /*----- Particles JS Config -----*/
    var $particles = $('#particles-js');
    if($particles.length) {

        particlesJS("particles-js", {
            "particles": {
                "number": {
                    "value": 80,
                    "density": {
                        "enable": true,
                        "value_area": 800
                    }
                },
                "color": {
                    "value": "#ffffff"
                },
                "shape": {
                    "type": "circle",
                    "stroke": {
                        "width": 0,
                        "color": "#000000"
                    },
                    "polygon": {
                        "nb_sides": 5
                    },
                    "image": {
                        "src": "img/github.svg",
                        "width": 100,
                        "height": 100
                    }
                },
                "opacity": {
                    "value": 0.5,
                    "random": false,
                    "anim": {
                        "enable": false,
                        "speed": 1,
                        "opacity_min": 0.1,
                        "sync": false
                    }
                },
                "size": {
                    "value": 3,
                    "random": true,
                    "anim": {
                        "enable": false,
                        "speed": 40,
                        "size_min": 0.1,
                        "sync": false
                    }
                },
                "line_linked": {
                    "enable": true,
                    "distance": 150,
                    "color": "#ffffff",
                    "opacity": 0.4,
                    "width": 1
                },
                "move": {
                    "enable": true,
                    "speed": 4,
                    "direction": "none",
                    "random": false,
                    "straight": false,
                    "out_mode": "out",
                    "bounce": false,
                    "attract": {
                        "enable": false,
                        "rotateX": 600,
                        "rotateY": 1200
                    }
                }
            },
            "interactivity": {
                "detect_on": "canvas",
                "events": {
                    "onhover": {
                        "enable": true,
                        "mode": "repulse"
                    },
                    "onclick": {
                        "enable": true,
                        "mode": "push"
                    },
                    "resize": true
                },
                "modes": {
                    "grab": {
                        "distance": 400,
                        "line_linked": {
                            "opacity": 1
                        }
                    },
                    "bubble": {
                        "distance": 400,
                        "size": 40,
                        "duration": 2,
                        "opacity": 8,
                        "speed": 3
                    },
                    "repulse": {
                        "distance": 200,
                        "duration": 0.4
                    },
                    "push": {
                        "particles_nb": 4
                    },
                    "remove": {
                        "particles_nb": 2
                    }
                }
            },
            "retina_detect": false
        });

    }

})(jQuery);
