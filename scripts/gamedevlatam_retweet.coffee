# Description
#   Script afanado del retweet coffee para usarlo en latam
#
# Commands:
#   hubot ayudame con los retweets vieja - Te tira toda la data
#   hubot retweet key: KEY secret: SECRET - Te guarda las keys
#   hubot retweeteame latam ID - Le dice a todos que te retweeteen
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWEETER_ACCOUNTS
#
# Author:
#   genkido

# Class for access keys
class TwitterCredentials
  enabled: false
  
  constructor: (@key, @secret) ->

Twit = require "twit"
config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
#  consumer_key: HUBOT_TWITTER_CONSUMER_KEY
#  consumer_secret: HUBOT_TWITTER_CONSUMER_SECRET

unless config.consumer_key
  console.log "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
unless config.consumer_secret
  console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."


module.exports = (robot) ->
  # Post help
  robot.respond /ayudame con los retweets vieja/i, (msg) ->
    msg.reply "Entra en http://genkidogames.com/twitCred/login.php y pasame " +
      "las credenciales con \"@dalek retweet key: KEY secret: SECRET\""
    msg.reply "Despues dale \"@dalek retweeteame latam ID\" con el ID del tweet"
    return

  # Accept terms
  robot.respond /Si, acepto/i, (msg) ->
    msg.message.user.retweet_creds.enabled = true
    msg.reply "BUENA PIBE! Todo listo tonces, tirame el tweet."
    return

  # Read credentials and save them
  robot.respond /retweet key: (.+) secret: (.+)/i, (msg) ->
    twitterCred = new TwitterCredentials msg.match[1], msg.match[2]
    # Check if credentials are valid
    T = new Twit
      consumer_key:         config.consumer_key
      consumer_secret:      config.consumer_secret
      access_token:         twitterCred.key
      access_token_secret:  twitterCred.secret

    T.get "search/tweets",
      q: "banana"
    , (err, reply) ->
      if err
        msg.reply msg.message.user.name + " Poly no quiere esa galleta"

      else
        msg.message.user.retweet_creds = twitterCred
        msg.reply msg.message.user.name + " todo joya"
        msg.reply msg.message.user.name + " leete las reglas: \n1. Esto es solo para tweets de desarrollo de juegos nuestros. No poner comida, o giladas como esas o hay tabla.\n2. Esto es solo para tweets nuestros: por mucha risa que te cause lo que dijo fulano, no lo pongas aca.\n3. No spamees: es dificil saber cuando uno spamea o no, pero si pones algo cada 1 hora, probablemente estes spameando. (Spamea todo lo que quieras, pero no pongas eso aca para retweets :P)\n4. No pongas conversaciones: No importa que discutiendo con Carmack si reventar cajas de cepita es una buena mecanica o no- nada de conversaciones (o hay tabla). EXCEPCION: Si le estas mandando un tweet a Unity u otro engine para que te lo retwitee, esta todo bien.\nDecime \"Si, acepto\" cuando termines\n5. CERO Profanity/Porno/Cosas burdas o que rayen los limites: Tene en mente que aca se anotaron otros tipos como vos para ayudarse, pero no son como vos: tienen otros amigos, se visten distinto, y puede que alguno sea un flogger encubierto. Los circulos de ellos muy probablemente sean distintos a los que te moves vos y no a todos les parece interesante la leyenda del indio que usa el pingo de cinturon.\n6. Nada de hashtags \"de moda\" o controversiales: algunos se suben a estas cosas para tener mas exposicion pero no siempre funciona. Si vos lo haces, esta todo bien, pero no lo pongas para retweet automatico porque podemos quedar todos como pelotudos.\n\nEn definitiva, si vas a hacer algo y no te gustaria que te lo hiciesen a vos, a tu hermana o a tu perro, no lo hagas. Asi seguimos todos siendo amigos, alcanzamos mas audiencia para nuestros juegos y nos vamos a las manos.\n\n\nCualquier problema con el bot, le dicen a @ironicnet o a @genkido.\nBesis"

    return

  # Retween from all accounts
  robot.respond /retweeteame latam (.+)/i, (msg) ->
    unless msg.message.user.retweet_creds
      msg.reply msg.message.user.name + " configurate las credenciales " +
        "lince intergalactico"
      return

    unless msg.message.user.retweet_creds.enabled
      msg.reply msg.message.user.name + " no podes retwittear hasta no aceptar las reglas"
      msg.reply msg.message.user.name + " leete las reglas: \n1. Esto es solo para tweets de desarrollo de juegos nuestros. No poner comida, o giladas como esas o hay tabla.\n2. Esto es solo para tweets nuestros: por mucha risa que te cause lo que dijo fulano, no lo pongas aca.\n3. No spamees: es dificil saber cuando uno spamea o no, pero si pones algo cada 1 hora, probablemente estes spameando. (Spamea todo lo que quieras, pero no pongas eso aca para retweets :P)\n4. No pongas conversaciones: No importa que discutiendo con Carmack si reventar cajas de cepita es una buena mecanica o no- nada de conversaciones (o hay tabla). EXCEPCION: Si le estas mandando un tweet a Unity u otro engine para que te lo retwitee, esta todo bien.\nDecime \"Si, acepto\" cuando termines\n5. CERO Profanity/Porno/Cosas burdas o que rayen los limites: Tene en mente que aca se anotaron otros tipos como vos para ayudarse, pero no son como vos: tienen otros amigos, se visten distinto, y puede que alguno sea un flogger encubierto. Los circulos de ellos muy probablemente sean distintos a los que te moves vos y no a todos les parece interesante la leyenda del indio que usa el pingo de cinturon.\n6. Nada de hashtags \"de moda\" o controversiales: algunos se suben a estas cosas para tener mas exposicion pero no siempre funciona. Si vos lo haces, esta todo bien, pero no lo pongas para retweet automatico porque podemos quedar todos como pelotudos.\n\nEn definitiva, si vas a hacer algo y no te gustaria que te lo hiciesen a vos, a tu hermana o a tu perro, no lo hagas. Asi seguimos todos siendo amigos, alcanzamos mas audiencia para nuestros juegos y nos vamos a las manos.\n\n\nCualquier problema con el bot, le dicen a @ironicnet o a @genkido.\nBesis"
      return

    tweetId = msg.match[1]
    users = robot.brain.users()
    replyMessage = "Retweeteado desde: "
    
    for k of (users or {})
      tmpUser = users[k]
      unless tmpUser == msg.message.user
        if tmpUser.retweet_creds
          try
            T = new Twit
              consumer_key:         config.consumer_key
              consumer_secret:      config.consumer_secret
              access_token:         tmpUser.retweet_creds.key
              access_token_secret:  tmpUser.retweet_creds.secret


            T.post "statuses/retweet/" + tweetId,
              id: tweetId
            , (err, reply) ->

              if err
                data = JSON.parse(err.data).errors[0]
                msg.reply "No pude retweetear con " + tmpUser.name + ": #{data.message} (error #{data.code})"
                return

              replyMessage = replyMessage + tmpUser.name + ", "

          catch error
            msg.reply error

    msg.reply replyMessage
    return
