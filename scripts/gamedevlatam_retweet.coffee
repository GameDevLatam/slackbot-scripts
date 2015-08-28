# Description
# 	Script afanado del retweet coffee para usarlo en latam
#
# Commands:
#   hubot ayudame con los retweets vieja - Te tira toda la data
#   hubot retweet key: KEY secret: SECRET - Te guarda las keys
#   hubot retweeteame latam ID - Le dice a todos que te retweeteen
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

# Take consumer key and from script (easier if they don't change)
HUBOT_TWITTER_CONSUMER_KEY = "XsY4DFSb9ULtHWchD4cojzf8B"
HUBOT_TWITTER_CONSUMER_SECRET = "FLe4dbOVUfarLnm7XcNH4MRvWb5NplzHoTsMy6kKsMb5ClaCcr"

# Class for access keys
Class TwitterCredentials

  constructor: (key, secret) ->
    @key    = key
    @secret = secret


Twit = require "twit"
config =
  consumer_key: HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: HUBOT_TWITTER_CONSUMER_SECRET


module.exports = (robot) ->
	# Post help
	robot.respond /ayudame con los retweets vieja/i, (msg) ->
		msg.reply "Entra en http://genkidogames.com/twitCred/login.php y pasame las credenciales con \"@dalek retweet key: KEY secret: SECRET\""
		msg.reply "Despues dale \"@dalek retweeteame latam ID\" con el ID del tweet"
		return

	# Read credentials and save them
	robot.respond /retweet key: (.+) secret: (.+)/i, (msg) ->
		twitterCred = new TwitterCredentials msg.match[1], msg.match[2]
		# Check if credentials are valid
		var T = new Twit
			consumer_key:         config.consumer_key
			consumer_secret:      config.consumer_secret
			access_token:         tweeterCred.key
			access_token_secret:  tweeterCred.secret

		twit.get "search/tweets",
			q: "banana",
			(err, reply) ->
			if err
				msg.reply msg.message.user.name + " Poly no quiere esa galleta"
				return

			else
				msg.message.user.retweet_creds = twitterCred
				msg.reply msg.message.user.name + " todo joya"
				return

		return

	# Retween from all accounts
	robot.respond /retweeteame latam (.+)/i, (msg) ->
		unless msg.message.user.retweet_creds
			msg.reply msg.message.user.name + " configurate las credenciales lince intergalactico"
			return

		tweetId = msg.match[1]
		users = robot.brain.users
		for k of (users or {})
			tmpUser = users[k]
			unless tmpUser == msg.message.user
				if tmpUser.retweet_creds
					var T = new Twit
						consumer_key:         config.consumer_key
						consumer_secret:      config.consumer_secret
						access_token:         tmpUser.retweet_creds.key
						access_token_secret:  tmpUser.retweet_creds.secret

					T.post "statuses/retweet/:id",
						id: tweetId,
						(err, reply) ->

						if err
							msg.reply "No pude retweetear con " + user.name

						return
						
		
		return