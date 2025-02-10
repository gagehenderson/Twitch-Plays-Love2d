# Twitch-Plays-Love2d
Using twitch chat to play games, using LÖVE to easily display some info and stuff.

## Getting Started

1. Create your twitch app in the [twitch developer console](https://dev.twitch.tv/console).
    1a. Should be a public app.
    2a. Add a `http://localhost` redirect.
2. Get your oauth token.
    2a. Can do this manually with this url:
    `https://id.twitch.tv/oauth2/authorize
    ?client_id=YOUR_CLIENT_ID
    &redirect_uri=http://localhost
    &response_type=token
    &scope=chat:read+chat:edit`
    2b. Then copy the token from the url.
3. Create a `config.lua` file and put your oauth token in it:
    ```lua
    return {
        oauth_token = "YOUR_OAUTH_TOKEN"
    }
    ```
