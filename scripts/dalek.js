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
	
  robot.hear(/joined #general/, function (msg)
  {
    msg.send("Bienvenido "+msg.message.user.name+"!");
    msg.finish();
  });

	robot.hear(/soy (nuevo)/i, function (msg)
	{
		var name = msg.message.user.name;
		msg.send("Hola @"+name+"! Te recomiendo que leas este post para saber de donde obtener recursos: http://foro.adva.vg/t/post-introductorio-para-el-desarrollo-de-videojuegos/125");
    msg.finish();
	});
	robot.respond(/(bye|adios|chau) mitsuku/i, function (res)
	{
		useMitsuku = false;
	});
	robot.respond(/(hi|hola) mitsuku/i, function (res)
	{
		useMitsuku = true;
	});
	robot.respond(/(.*)/i, function(res)
  {
	if (useMitsuku)
	{
        mit.send(res.match[1]).then(function(response) {
          res.send(response);
          res.finish();
        });
	}
  });
};