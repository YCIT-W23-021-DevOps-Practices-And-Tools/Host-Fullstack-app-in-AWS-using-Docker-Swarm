const express = require('express')
const app = express()

const mysql = require('mysql2')
const bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())


let mysqlConnection;

const dbInit = async () => {
  if (mysqlConnection) {
    return;
  }
  try {
    mysqlConnection = await mysql.createConnection({
      host: process.env.DB_DOCKER_HOST,
      port: process.env.DB_DOCKER_PORT,
      user: process.env.DB_DOCKER_USER,
      database: process.env.DB_DOCKER_DB_NAME,
      password: process.env.DB_DOCKER_PASSWORD
    });
  }
  catch (err) {
    //
  }

}



const fields = [
  'first_name',
  'last_name',
  'cell_phone',
  'age'
]

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.put('/user', async (req, res, next) => {
  try {
    await dbInit();
    const body = req.body

    Object.keys(body).forEach((item) => {
      if (!fields.includes(item)) {
        throw new Error(`key ${item} is not supported`)
      }
    })

    const { first_name, last_name, cell_phone, age } = body;
    const insertQuery = `INSERT INTO users ( first_name, last_name, cell_phone, age ) VALUES ( '${first_name}', '${last_name}', '${cell_phone}', ${age} )`;
    const resultOfInserting = await mysqlConnection.promise().query(insertQuery);
    res.send({
      message: `${JSON.stringify(body)} is stored successfully with id ${resultOfInserting[0].insertId}`,
      insertId: resultOfInserting[0].insertId
    })
  }
  catch (err) {
    next(err)
  }
})


app.patch('/user', async (req, res, next) => {
  try {
    await dbInit();
    const body = req.body

    if (!body.id) {
      throw new Error('id is not exist')
    }

    const newFields = ['id', ...fields];

    Object.keys(body).forEach((item) => {
      if (!newFields.includes(item)) {
        throw new Error(`key ${item} is not supported`)
      }
    })

    const { first_name, last_name, cell_phone, age } = body;
    const updateQuery = `UPDATE users set  first_name='${first_name}', last_name='${last_name}', cell_phone='${cell_phone}', age=${age}    where id=${body.id}`;
    const resultOfInserting = await mysqlConnection.promise().query(updateQuery);
    res.send({
      message: `${JSON.stringify(body)} successfully updated!, with id ${body.id}`
    })
  }
  catch (err) {
    next(err)
  }

})


app.listen(3000, () => {
  console.log('Example app listening on port 3000')
})
