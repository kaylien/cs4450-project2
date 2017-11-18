export var SoundcloudModule = {

    runSoundcloud: function(){
        var widget = SC.Widget("soundcloud_player");

        var songUrl = "https://soundcloud.com/scumgang6ix9ine/gummo-prod-pierre-bourne";

        // Set listeners
        widget.bind(SC.Widget.Events.READY, onPlayerReady);

        // The API will call this function when the video player is ready.
        function onPlayerReady(event) {
            widget.getDuration(function(data){
                
                soundcloudDuration = data - 1;

                widget.bind(SC.Widget.Events.PLAY, onPlay);
                widget.bind(SC.Widget.Events.PAUSE, onPause);
                widget.bind(SC.Widget.Events.FINISH, onFinish);

                // Variables useful for when the state changes
                var endedAfterEnoughTime = false;
                var timeoutVariable;
                var soundcloudDuration;
                var timeSoundcloudTimerStarted;
                var timeElapsedOfSoundcloudTimer = 0;
                var totalSoundcloudTime = 0;

                function onPlay(){
                    endedAfterEnoughTime = false;
                    timeSoundcloudTimerStarted = (new Date()).getTime();
                    if (!timeoutVariable){
                        timeoutVariable = setTimeout(function(){ endedAfterEnoughTime = true; }, soundcloudDuration - totalSoundcloudTime);
                    }
                }

                function onPause(){
                    timeElapsedOfSoundcloudTimer = (new Date()).getTime() - timeSoundcloudTimerStarted;
                    totalSoundcloudTime += timeElapsedOfSoundcloudTimer;
                    clearTimeout(timeoutVariable);
                    timeoutVariable = undefined;
                }

                function onFinish(){
                    clearTimeout(timeoutVariable);
                    timeoutVariable = undefined;
                    totalSoundcloudTime = 0;
                    timeElapsedOfSoundcloudTimer = 0;
                    if (endedAfterEnoughTime){
                        console.log("Stream counts!");
                    }else{
                        console.log("Stream doesn't count!");
                    }
                    widget.load(songUrl, {auto_play: true});
                }

                // Start song
                widget.play();

            });
        }
    }

}

export default SoundcloudModule