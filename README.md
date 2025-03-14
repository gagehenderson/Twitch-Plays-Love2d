# Twitch-Plays-Love2d
Using twitch chat to play games, using LÖVE. Only works on Windows due to how 
we simulate keyboard input.
  
![Screenshot](screenshot.png?raw=true)  
  
## Setup

1. Create your twitch app in the [twitch developer console](https://dev.twitch.tv/console).  
    - Should be a public app.  
    - Add a `http://localhost` redirect.
2. Get your oauth token.  
    - Can do this manually with this url:
    `https://id.twitch.tv/oauth2/authorize?client_id=YOUR_CLIENT_ID&redirect_uri=http://localhost&response_type=token&scope=chat:read+chat:edit`  
    - Then copy the token from the url.  
3. Create a `config.lua` file and define the following:
    ```lua
    return {
        oauth_token = "Your oauth token",
        channel = "The channel you want to join",
        username = "The username you want to use",
        game_config = "Name of the game config file (Example: "trackmania")",
    }
    ```
## Running

1. Install [LÖVE](https://love2d.org/).  
2. Run project.
    - Run `love .` in the project directory.
    - Alternatively:
        - Compress project files into a zip file.
        - Rename file extension from `.zip` to `.love`.
        - Double click the `.love` file.
     
## Usage
- Press `delete` to kill the app immediately, even when not currently focused on the app window.
