export var SoundcloudModule = {

    runSoundcloud: function(){
        var widget = SC.Widget("soundcloud_player");

        var songUrl = document.querySelector("#soundcloud_id").getAttribute("data-url");
        var roomId = document.querySelector("#room_id").getAttribute("data-url");
        var url = "/api/rooms_users/" + roomId + "/soundcloud";

        // Set listeners
        widget.bind(SC.Widget.Events.READY, onPlayerReady);

        // The API will call this function when the video player is ready.
        function onPlayerReady(event) {
            widget.getDuration(function(data){
                
                var soundcloudDuration = data - 1;

                widget.bind(SC.Widget.Events.PLAY, onPlay);
                widget.bind(SC.Widget.Events.PAUSE, onPause);
                widget.bind(SC.Widget.Events.FINISH, onFinish);

                // Variables useful for when the state changes
                var endedAfterEnoughTimeSoundcloud = false;
                var timeoutSoundcloudVariable;
                var timeSoundcloudTimerStarted;
                var timeElapsedOfSoundcloudTimer = 0;
                var totalSoundcloudTime = 0;

                function onPlay(){
                    endedAfterEnoughTimeSoundcloud = false;
                    timeSoundcloudTimerStarted = (new Date()).getTime();
                    console.log(soundcloudDuration);
                    console.log(soundcloudDuration - totalSoundcloudTime);
                    if (!timeoutSoundcloudVariable){
                        timeoutSoundcloudVariable = setTimeout(function(){ endedAfterEnoughTimeSoundcloud = true; }, soundcloudDuration - totalSoundcloudTime);
                    }
                }

                function onPause(){
                    timeElapsedOfSoundcloudTimer = (new Date()).getTime() - timeSoundcloudTimerStarted;
                    totalSoundcloudTime += timeElapsedOfSoundcloudTimer;
                    clearTimeout(timeoutSoundcloudVariable);
                    timeoutSoundcloudVariable = undefined;
                }

                function onFinish(){
                    clearTimeout(timeoutSoundcloudVariable);
                    timeoutSoundcloudVariable = undefined;
                    totalSoundcloudTime = 0;
                    timeElapsedOfSoundcloudTimer = 0;
                    endedAfterEnoughTimeSoundcloud = true;
                    if (endedAfterEnoughTimeSoundcloud){
                        console.log("Soundcloud stream counts!");
                        $.ajax({
                            url: url,
                            type: 'PATCH',
                            success: function(res) {
                                var responseMessage = JSON.parse(res);
                                if (responseMessage["result"] == "ok"){
                                    // Do something
                                }
                            },
                            error: function(xhr, ajaxOptions, thrownError) {
                                var responseMessage = JSON.parse(xhr.responseText);
                                console.log("COULD NOT INCREMENT: " + responseMessage["message"]);
                            }
                        });
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