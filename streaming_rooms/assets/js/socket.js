// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.


function onReceiveUserJoined(data) {
    
    let listOfUsersDiv = document.getElementById("list_of_users_connected")
    
    if (listOfUsersDiv != undefined){

       	var username = data.username
        var value = listOfUsersDiv.innerHTML;
        var listOfUsernames = value.split(",");
        var alreadyInList = false;
        var newListOfUsers = [];
        var j = 0;

        for (var i=0; i<listOfUsernames.length; i++) {
            if (listOfUsernames[i].trim() == username){
                alreadyInList = true;
            }
            if (listOfUsernames[i].trim() != ""){
                newListOfUsers[j] = listOfUsernames[i];
                j++;
            }
        }

        if (!alreadyInList){
        	if (listOfUsernames[0] == "" || listOfUsernames[listOfUsernames.length-1].trim() == ""){
            	listOfUsersDiv.append(username);
        	}else{
            	listOfUsersDiv.append(", " + username);
        	}
        }else{
            listOfUsersDiv.innerHTML = "";
            for(var i = 0; i<j; i++) {
                if (i + 1 == j){
                    listOfUsersDiv.append(newListOfUsers[i]);
                }else{
                    listOfUsersDiv.append(newListOfUsers[i] + ", ");
                }
            }
        }

    }

}

function onReceiveUserLeft(data){

    let listOfUsersDiv = document.getElementById("list_of_users_connected");
    
    if (listOfUsersDiv != undefined){

        var username = data.username;
        var value = listOfUsersDiv.innerHTML;
        var listOfUsernames = value.split(",");
        var newListOfUsers = [];
        var j = 0;

        for (var i=0; i<listOfUsernames.length; i++) {
            if (listOfUsernames[i].trim() != "" && listOfUsernames[i].trim() != username){
                newListOfUsers[j] = listOfUsernames[i];
                j++;
            }
        }

        listOfUsersDiv.innerHTML = "";
        for(var i = 0; i<j; i++) {
            if (i + 1 == j){
                listOfUsersDiv.append(newListOfUsers[i]);
            }else{
                listOfUsersDiv.append(newListOfUsers[i] + ", ");
            }
        }
    }
}

if (document.getElementById("list_of_users_connected") != undefined){

	socket.connect();

	// Now that you are connected, you can join channels with a topic:
	let channel = socket.channel("room:" + roomId, {})
	channel.join()
	    .receive("ok", resp => { 
	        console.log("Joined successfully", resp);
	        channel.push("user_just_joined_room", {
	            username: username
	        });
	    })
	    .receive("error", resp => { console.log("Unable to join", resp) })

	channel.on("user_just_joined_room", onReceiveUserJoined);
    channel.on("user_left_room", onReceiveUserLeft)

    var backButton = document.getElementById("back_button");
    backButton.addEventListener("click", function(){
        channel.push("user_left_room", {
            username: username
        });
    }, false);

}


export default socket