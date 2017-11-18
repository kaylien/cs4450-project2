// The base code was gotten from the Youtube official page: https://developers.google.com/youtube/iframe_api_reference

// This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var videoId = "qooQd8AA7_M";

// This function creates an <iframe> (and YouTube player) after the API code downloads.
var youtubePlayer;
function onYouTubeIframeAPIReady() {
	    youtubePlayer = new YT.Player('youtube_player', {
        height: '390',
        width: '640',
        videoId: videoId,
        events: {
        	'onReady': onPlayerReady,
        	'onStateChange': onPlayerStateChange
        }
    });
}

// The API will call this function when the video player is ready.
function onPlayerReady(event) {
	event.target.playVideo();
}

// Variables useful for when the state changes
var endedAfterEnoughTime = false;
var timeoutVariable;
var youtubeDuration;
var timeYoutubeTimerStarted;
var timeElapsedOfYoutubeTimer = 0;
var totalYoutubeTime = 0;

function onPlayerStateChange(event) {
    state = event.data
    if (state == YT.PlayerState.ENDED){
    	clearTimeout(timeoutVariable);
        timeoutVariable = undefined;
        totalYoutubeTime = 0;
        timeElapsedOfYoutubeTimer = 0;
        if (endedAfterEnoughTime){
            console.log("Stream counts!");
        }else{
            console.log("Stream doesn't count!");
        }
        youtubePlayer.loadVideoById(videoId);
    }else if (state == YT.PlayerState.PAUSED){
        timeElapsedOfYoutubeTimer = (new Date()).getTime() - timeYoutubeTimerStarted;
        totalYoutubeTime += timeElapsedOfYoutubeTimer;
        clearTimeout(timeoutVariable);
        timeoutVariable = undefined;
    }else if (state == YT.PlayerState.PLAYING){
        endedAfterEnoughTime = false;
        if (!youtubeDuration && youtubePlayer.getDuration() > 0){
            youtubeDuration = (youtubePlayer.getDuration() - 1) * 1000;
        }
        timeYoutubeTimerStarted = (new Date()).getTime();
        if (!timeoutVariable){
            timeoutVariable = setTimeout(function(){ endedAfterEnoughTime = true; }, youtubeDuration - totalYoutubeTime);
        }
    }
}