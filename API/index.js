/*
RESTFUL Services by NodeJS
Author: Yafet Shil
*/
var crypto = require('crypto');
var uuid = require ('uuid');
var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var multer, storage, path, crypto;
multer = require('multer');
//path = require('fs');
//var upload = multer({ dest: 'Documents/ESPRIT/Semestre\ 1/AndroidMiniProject/API/upload/' });
var upload = multer({ dest: './upload' });
//var upload = multer({ dest: 'upload/' });


var fs = require('fs');

var app=express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
//cmnt
//Connect to MySQL
var con = mysql.createConnection({
    host:'127.0.0.1',
    port: '8889',
    user: 'root',
    password: 'root',
    connector: 'mysql',
    database: 'miniprojet',
    socketPath: '/Applications/MAMP/tmp/mysql/mysql.sock'
});

//Connect to MySQL
/*var con = mysql.createConnection({
    host:'127.0.0.1',
    port: '3306',
    user: 'root',
    password: '',
    connector: 'mysql',
    database: 'miniprojet',
});*/



con.connect((err)=> {
    if(!err)
        console.log('Connection Established Successfully');
    else
        console.log('Connection Failed!'+ JSON.stringify(err,undefined,2));
});

//PASSWORD CRYPT
var genRandomString = function (length) {
    return crypto.randomBytes(Math.ceil(length/2))
        .toString('hex') //Convert to hexa format
        .slice(0,length);
    
};
var sha512 = function (password,salt) {
    var hash = crypto.createHmac('sha512',salt) ; //Use SHA512
    hash.update(password);
    var value = hash.digest('hex');
    return {
        salt:salt,
        passwordHash:value
    };
    
};
/* Hash password */
function saltHashPassword(userPassword) {
    var salt = genRandomString(16); //Gen Random string with 16 charachters
    var passwordData = sha512(userPassword,salt) ;
    return passwordData;
    
}
function checkHashPassword(userPassword,salt) {
    var passwordData = sha512(userPassword,salt);
    return passwordData;
    
}



storage = multer.diskStorage({
    destination: './uploads/',
    filename: function(req, file, cb) {
        return crypto.pseudoRandomBytes(16, function(err, raw) {
            if (err) {
                return cb(err);
            }
            return cb(null, "" + (raw.toString('hex')) + (path.extname(file.originalname)));
        });
    }
});

// Post files
app.post(
    "/upload",
    multer({
        storage: storage
    }).single('upload'), function(req, res) {
        console.log(req.file);
        console.log(req.body);
        res.redirect("/uploads/" + req.file.filename);
        console.log(req.file.filename);
        return res.status(200).end();
    });


app.get('/uploads/:upload', function (req, res){
    file = req.params.upload;
    console.log(req.params.upload);
    var img = fs.readFileSync(__dirname +"/upload/"+ file);
    //res.writeHead(200, {'Content-Type': 'image/png' });
    res.end(img, 'binary');

});

/* REGISTER */
app.post('/register/',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var uid = uuid.v4();   //Get  UUID V4
    var plaint_password = post_data.password ;  //Get password from post params
    var hash_data = saltHashPassword(plaint_password);
    var password = hash_data.passwordHash;  //Get Hash value
    var salt = hash_data.salt; //Get salt

    var name = post_data.name;
    var email = post_data.email;
    var prenom = post_data.prenom;
    var tel_user = post_data.tel_user;
    var image_user = post_data.image_user;

    con.query('SELECT * FROM user where email=?',[email],function (err,result,fields) {

        if (result && result.length)
            res.json('Cette adresse mail est déjà utilisé');
        else {
            con.query('INSERT INTO `user`(`unique_id`, `name`, `email`, `encrypted_password`, `salt`, `created_at`, `updated_at`, `prenom`, `tel_user`, `image_user`) ' +
                'VALUES (?,?,?,?,?,NOW(),NOW(),?,?,?)',[uid,name,email,password,salt,prenom,tel_user,image_user],function (err,result,fields) {
               if (err) throw err;

                res.json('Vous ètes inscrit avec succés');

            })
        }
    });

})

/* LOGIN */

app.post('/login/',(req,res,next)=>{
    var post_data = req.body;

    //Extract email and password from request
    var user_password = post_data.password;
    var email = post_data.email;

    con.query('SELECT * FROM user where email=?',[email],function (err,result,fields) {
        if (result && result.length)
            {
                var salt = result[0].salt;
                var encrypted_password = result[0].encrypted_password;
                var hashed_password = checkHashPassword(user_password, salt).passwordHash;
                if (encrypted_password == hashed_password)
                    res.send({ user:result });
                else
                    res.end(JSON.stringify('Vérifiez votre mot de passe'));
            }
        else {

                res.json('Utilisateur introuvable');

         }

    });


})
/* UPDATE PROFILE */
app.put('/user/edit/:id', (req, res) => {


    const id = req.params.id;
    con.query('UPDATE user SET ? WHERE id = ?', [req.body, id], (error, result) => {
        if (error) throw error;

        res.send('Porifle modifié avec succés');
    });

});

/* UPDATE IMAGE PROFILE */
app.put('/user/edit/image/:id', upload.single('file'), (req, res) => {
    var imageData = fs.readFileSync(req.file.path);

    const id = req.params.id;
    con.query('UPDATE user SET image_user = ? WHERE id = ?', [req.file.filename, id], (error, result) => {
        if (error) throw error;

        res.json("Image uploaded")


    });

});

/* SHOW PROFILE DETAILS */
app.get('/user/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;


    con.query('SELECT * FROM `user` WHERE id =?' ,[id],  (error, result) => {
        if (error) throw error;

        res.send(result);
        console.log(result);
    });

});



/* SHOW EVENT */
app.get('/evenement/show', (req, res) => {

    con.query('SELECT * FROM evenement',((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW ARTICLE */
app.get('/article/show', (req, res) => {

    con.query('SELECT * FROM article',((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW ARTICLE A LOUER */
app.get('/article/louer', (req, res) => {

    con.query('SELECT * FROM article where type_article = "location" ',((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW ARTICLE A VENDRE */
app.get('/article/vendre', (req, res) => {

    con.query('SELECT * FROM article where type_article = "vente" ',((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW MY ARTICLE */
app.get('/myarticle/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;
    con.query('SELECT * FROM article WHERE id_user =?',[id],((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW MY EVENT */
app.get('/myevent/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;
    con.query('SELECT * FROM evenement WHERE id_user =?',[id],((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* ADD EVENT */
app.post('/evenement/add',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var nom_evenement = post_data.nom_evenement;
    var type_evenement = post_data.type_evenement;
    var date_debut_evenement = post_data.date_debut_evenement;
    var date_fin_evenement = post_data.date_fin_evenement;
    var distance_evenement = post_data.distance_evenement;
    var photo_evenement = post_data.photo_evenement;
    var lieux_evenement = post_data.lieux_evenement;
    var infoline = post_data.infoline;
    var difficulte_evenement = post_data.difficulte_evenement;
    var prix_evenement = post_data.prix_evenement;
    var nbr_place = post_data.nbr_place;
    var description_evenement = post_data.description_evenement;
    var id_user = post_data.id_user;






    con.query('INSERT INTO `evenement`(`nom_evenement`, `type_evenement`, `date_debut_evenement`, `date_fin_evenement`, `distance_evenement`, `photo_evenement`, `lieux_evenement`,`infoline`,`difficulte_evenement`,`prix_evenement`,`nbr_place`,`description_evenement`,`id_user`) ' +
        'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',[nom_evenement,type_evenement,date_debut_evenement,date_fin_evenement,distance_evenement,photo_evenement,lieux_evenement,infoline,difficulte_evenement,prix_evenement,nbr_place,description_evenement,id_user],function (err,result,fields) {
                if (err) throw err;

                res.json('Evenement ajouté avec succés');

            });

    })

/* SHOW EVENT DETAILS */
app.get('/evenement/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;


    con.query('SELECT * FROM `evenement` WHERE id_evenement =?' ,[id],  (error, result) => {
       // if (error) throw error;

        if(!error){
            res.send({ evenement:result });
        }
        else {
            console.log(error)

        }
    });

});
/* SHOW ARTICLE DETAILS */
app.get('/article/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;


    con.query('SELECT * FROM `article` WHERE id_article =?' ,[id],  (error, result) => {
        // if (error) throw error;

        if(!error){
            res.send({ article:result });
        }
        else {
            console.log(error)

        }
    });

});


/* DELETE EVENT*/

app.delete('/evenement/delete/:id',(req, res) => {
    const id = req.params.id;
    let sql = 'DELETE from evenement where id_evenement =?';
    let query = con.query(sql,[id],(err, result) => {
        if(err) throw err;
        res.send('Evènement supprimé avec succés');
    });
});

/* UPDATE EVENT */
app.put('/evenement/edit/:id', (req, res) => {

    const id = req.params.id;
    con.query('UPDATE evenement SET ? WHERE id_evenement = ?', [req.body, id], (error, result) => {
        if (error) throw error;

        res.send('Evenement modifié avec succés');
    });
});

/* ADD ARTICLE */
app.post('/article/add',(req,res,next)=>{
    var post_data = req.body;  //Get POST params
    var titre_article = post_data.titre_article;
    var type_article = post_data.type_article;
    var description_article = post_data.description_article;
    var location_article = post_data.location_article;
    var categorie_article = post_data.categorie_article;
    var sous_categorie_article = post_data.sous_categorie_article;
    var prix_article = post_data.prix_article;
    var image_article = post_data.image_article;
    var user_id = post_data.user_id;

let currentDate = Date.now();
    let date_ob = new Date(currentDate);
    let date = date_ob.getDate();
    let month = date_ob.getMonth() + 1;
    let year = date_ob.getFullYear();
    let dateFinal = year + "-" + month + "-" + date;






    con.query('INSERT INTO `article`( `titre_article`,`type_article`, `description_article`, `location_article`, `date_article`, `categorie_article`,`sous_categorie_article`, `prix_article`,`image_article`,`user_id`) ' +
        'VALUES (?,?,?,?,?,?,?,?,?,?)',[titre_article,type_article,description_article,location_article,dateFinal,categorie_article,sous_categorie_article,prix_article,image_article,user_id],function (err,result,fields) {
        if (err) throw err;

        res.json('Article ajouté avec succés');

    });

});
/* ADD PARTICIPANT */
app.post('/participant/add',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_user = post_data.id_user;
    var id_evenement = post_data.id_evenement;
    con.query('SELECT * FROM participants where id_user=? and id_evenement=?',[id_user,id_evenement],function (err,result,fields) {

        if (result && result.length)
            res.json('participated already');
        else {
            con.query('INSERT INTO `participants`(`id_user`, `id_evenement`)' +
                'VALUES (?,?)', [id_user, id_evenement], function (err, result, fields) {
                if (err) throw err;

                res.json('Participant ajouté avec succés');

            });

        }

});
});

/* VERIFY PARTICIPANT */
app.post('/participant/verify',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_user = post_data.id_user;
    var id_evenement = post_data.id_evenement;
    con.query('SELECT * FROM participants where id_user=? and id_evenement=?',[id_user,id_evenement],function (err,result,fields) {

        if (result && result.length)
            res.json('participated already');
        else {
            res.json('vous pouvez participer');


        }

    });
});

/* ADD FOLLOWER */
app.post('/follow/add',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_follower = post_data.id_follower;
    var id_following = post_data.id_following;
    con.query('SELECT * FROM follow where id_follower=? and id_following=?',[id_follower,id_following],function (err,result,fields) {

        if (result && result.length)
            res.json('abonné déjà');
        else {
            con.query('INSERT INTO `follow`(`id_follower`, `id_following`)' +
                'VALUES (?,?)', [id_follower, id_following], function (err, result, fields) {
                if (err) throw err;

                res.json('abonné avec succés');

            });

        }

    });
});



/* VERIFY FOLLOWER */
app.post('/follow/verify',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_follower = post_data.id_follower;
    var id_following = post_data.id_following;
    con.query('SELECT * FROM follow where id_follower=? and id_following=?',[id_follower,id_following],function (err,result,fields) {

        if (result && result.length)
        {
            res.json('abonné déjà');
        }
        else {
            res.json('vous pouvez abonner');

        }


    });
});

/* CANCEL FOLLOW */
app.delete('/follow/delete',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_follower = post_data.id_follower;
    var id_following = post_data.id_following;
    con.query('DELETE FROM `follow` WHERE id_follower=? and id_following=?', [id_follower, id_following], function (err, result, fields) {
        if (err) throw err;

        res.json('désabonné avec succés');

    });



});

/* CANCEL PARTICIPATION */
app.delete('/participant/delete',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_user = post_data.id_user;
    var id_evenement = post_data.id_evenement;
        con.query('DELETE FROM `participants` WHERE id_user=? and id_evenement=?', [id_user, id_evenement], function (err, result, fields) {
                if (err) throw err;

                res.json('participation annulé avec succés');

            });



    });

/* Increment nbr place*/
app.put('/annuler/:id', (req, res) => {
    const id = req.params.id;
    con.query(
        'UPDATE evenement SET nbr_place = nbr_place + 1 WHERE id_evenement = ? ',
        [id],
        function (err,result,fields) {
            if (err) throw err;

                res.json('incremented successfully');

        }
    );
});
/* Decrement nbr place*/
app.put('/participate/:id', (req, res) => {
    const id = req.params.id;
    con.query(
        'UPDATE evenement SET nbr_place = nbr_place - 1 WHERE id_evenement = ? and nbr_place > 0',
        [id],
        function (err,result,fields) {
            if (err) throw err;
            if (result.affectedRows > 0) {
                res.json('decremented successfully');
            } else {
                res.json('no more places');
            }
        }
    );
});


/* SHOW MY EVENTS */
app.get('/myevents/:id', (req, res) => {
    const id = req.params.id;


    con.query('SELECT * FROM evenement WHERE id_user = ?',[id],((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* Display which user creates the event */
app.get('/profile/event/:id', (req, res) => {

    const id = req.params.id;

    con.query('SELECT evenement.id_evenement, evenement.id_user ,user.id, user.name, user.prenom, user.image_user FROM evenement INNER JOIN user ON evenement.id_user = user.id where evenement.id_evenement = ? ',[id],((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* Display which user creates the article */
app.get('/profile/article/:id', (req, res) => {

    const id = req.params.id;

    con.query('SELECT article.id_article, article.user_id ,user.id, user.name, user.prenom FROM article INNER JOIN user ON article.user_id = user.id where article.id_article = ? ',[id],((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW MY ARTICLES */
app.get('/myarticles/:id', (req, res) => {
    const id = req.params.id;


    con.query('SELECT * FROM article WHERE user_id = ?',[id],((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});
/* SHOW PROFIL INFO */
app.get('/profil/info/:id', (req, res) => {
    const id = req.params.id;


    con.query('SELECT id,email,tel_user FROM user WHERE id = ?',[id],((err, results, fields) => {
        if(!err){
            res.send({ users:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW PROFIL ARTICLES */
app.get('/profil/article/:id', (req, res) => {
    const id = req.params.id;


    con.query('SELECT * FROM article WHERE user_id = ?',[id],((err, results, fields) => {
        if(!err){
            res.send({ articles:results });
        }
        else {
            console.log(err)

        }
    }))

});

/* SHOW PROFIL EVENTS */
app.get('/profil/event/:id', (req, res) => {
    const id = req.params.id;


    con.query('SELECT * FROM evenement WHERE id_user = ?',[id],((err, results, fields) => {
        if(!err){
            res.send({ evenements:results });
        }
        else {
            console.log(err)

        }
    }))

});
/* SEND MESSAGE */
app.post('/message/send',(req,res,next)=>{
    var post_data = req.body;  //Get POST params

    var id_sender = post_data.id_sender;
    var id_receiver = post_data.id_receiver;
    var message = post_data.message;


    con.query('INSERT INTO `message`(`id_sender`, `id_receiver`,`message`, `date_message`)' +
                'VALUES (?,?,?,NOW())', [id_sender, id_receiver, message], function (err, result, fields) {

            res.send('message envoyé avec succés');



    });
});








app.get('/message/show/:id', (req, res) => {
    var post_data = req.body;  //Get POST params

    const id = req.params.id;


    con.query('SELECT * FROM `message` WHERE id_sender =?' ,[id],  (error, result) => {
        // if (error) throw error;

        if(!error){
            res.send({ messages:result });
        }
        else {
            console.log(error)

        }
    });

});

/*var storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/uploads')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + '-' + Date.now()+'.'+file.originalname)
    }
});
var upload = multer({storage: storage});

module.exports = upload;


router.post('/upload',upload.single('profile'), function (req, res) {
    if (!req.file) {
        console.log("No file received");
        message = "Error! in image upload.";
        res.render('index',{message: message, status:'danger'});

    } else {
        console.log('file received');
        console.log(req.file.filename);
        message = "Successfully! uploaded";
        res.json({image: req.file.filename});
    }
});*/
//Start Server
app.listen(1337,()=>{
    console.log('Restful Running on port 1337');

})