// Description: 
//   TrollBot
//


module.exports = function (robot) {
	var active = true;
  var inactiveTime = 30; //Tiempo en minutos
  var inactiveTimer =null;
  var mit = require('mitsuku-api')(); 
  var useMitsuku = false;
  var unknown = ['Eh?','Que?', 'Mmm...', 'BEEP BEEP', 'What?', 'Que decis?', 'Que queres?', 'Que decias?', 'Lo que?','I DON SPIK INGLISH'];
	robot.hear(/gracias/i, function(res)
	{
    var denada = ['De nada', 'No hay porque', 'No hay de queso nomas de papa', 'Gracias hacen los monos'];
      if (active)
      {
        res.send(res.random(denada));
      }
	});
  
  /*robot.hear(/xD/, function(res)
	{
    if (active)
    {
      res.send(":stuck_out_tongue_closed_eyes:");
    }
	});*/
	
  robot.hear(/joined #general/, function (msg)
  {
    msg.send("Bienvenido "+msg.message.user.name+"!");
  });

	robot.hear(/soy (nuevo)/i, function (msg)
	{
		var name = msg.message.user.name;
		msg.send("Hola #{"+name+"}! Te recomiendo que leas este post para saber de donde obtener recursos: http://foro.adva.vg/t/post-introductorio-para-el-desarrollo-de-videojuegos/125");
	});
	
	robot.respond(/(.*)/i, function(res)
	{
		var command = res.match[1];
    if (command.toLowerCase()=="activate")
    {
      active = true;
      res.send('POWERING UP. BEEP BEEP BIP BEEP');
      if (inactiveTimer)
      {
        clearTimeout(inactiveTimer);
        inactiveTimer = null;
      }
      res.finish();
    }
    else if (command.toLowerCase()=="deactivate")
    {
      var timeSet = /deactivate ([0-9]+|forever)/i;
      var time = inactiveTime;
      var timeMatch = res.message.text.match(timeSet);
      if (timeMatch && timeMatch.length>1)
      {
          if (timeMatch[1].toLowerCase()=='forever')
          {
            time=0;
          }
          else
          {
            time = parseInt(timeMatch[1]);
          }
      }
      active = false;
      res.send("SHUTTING DOWN. Hasta la vista Baby");
      if (time>0)
      {
        inactiveTimer = setTimeout(function() 
        {
          active = true;
          res.reply("BEEP BEEP. I'M BACK BABY");
        }, time * 60 * 1000);
      }
      res.finish();
    }
    else if (command.toLowerCase()=="status")
    {
      res.send('Status:' + active);
      res.finish();
    }
    else if (comand.toLowerCase()=='mitsuku')
    {
      if (res.message.text.match(/mitsuku (on)/i).length>1)
      {
        useMitsuku = true;
      }
      else 
      {
        useMitsuku = false;
      }
      if (!useMitsuku)
      {
        res.send("Mitsuku desactivada");
      }
      else
      {
        res.send("Mitsuku activada");
      }
      res.finish();
    }
    else
    {      
      if (!useMitsuku)
      {
        res.send(res.random(unknown));
        res.finish();
      }
      else
      {
        mit.send(res.message.text).then(function(response) {
          res.send(response);
          res.finish();
        });
      }
    }
	});
};