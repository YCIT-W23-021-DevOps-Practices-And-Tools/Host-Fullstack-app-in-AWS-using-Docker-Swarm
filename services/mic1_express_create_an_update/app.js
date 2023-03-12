const express = require('express')
const app = express()

const mysql = require('mysql2')
const bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())


let mysqlConnection;

(async () => {
  mysqlConnection = await mysql.createConnection({
    host: process.env.DB_DOCKER_HOST,
    port: process.env.DB_DOCKER_PORT,
    user: process.env.DB_DOCKER_USER,
    database: process.env.DB_DOCKER_DB_NAME,
    password: process.env.DB_DOCKER_PASSWORD
  });
})()


const fields = [
  'first_name',
  'last_name',
  'cell_phone',
  'age'
]

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.put('/user', async (req, res) => {
  const body = req.body

  Object.keys(body).forEach((item) => {
    if (!fields.includes(item)) {
      throw new Error(`key ${item} is not supported`)
    }
  })

  const {first_name, last_name, cell_phone, age} = body;
  const insertQuery = `INSERT INTO users ( first_name, last_name, cell_phone, age ) VALUES ( '${first_name}', '${last_name}', '${cell_phone}', ${age} )`;
  const resultOfInserting = await mysqlConnection.promise().query(insertQuery);
  res.send({
    message: `${JSON.stringify(body)} is stored successfully with id ${resultOfInserting[0].insertId}`
  })
})

app.listen(3000, () => {
  console.log('Example app listening on port 3000')
})
