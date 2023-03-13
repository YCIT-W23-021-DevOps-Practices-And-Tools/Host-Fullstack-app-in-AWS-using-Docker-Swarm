from fastapi import FastAPI
import os
import mysql.connector

app = FastAPI()


mydb = mysql.connector.connect(
    host=os.environ.get('DB_DOCKER_HOST'),
    port=os.environ.get('DB_DOCKER_PORT'),
    user=os.environ.get('DB_DOCKER_USER'),
    password=os.environ.get('DB_DOCKER_PASSWORD'),
    database=os.environ.get('DB_DOCKER_DB_NAME')
)

mycursor = mydb.cursor(dictionary=True)


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/users")
async def usersGet():
    mycursor.execute("SELECT * FROM users")
    users = mycursor.fetchall()
    return users


@app.get("/users/{user_id}")
async def userGet(user_id):
    mycursor.execute(
        "SELECT * FROM users where id={user_id}".format(user_id=user_id))
    users = mycursor.fetchall()
    if len(users) > 0:
        return users[0]
    else:
        return {}


@app.delete("/users/{user_id}")
async def userDelete(user_id):
    user = await userGet(user_id)
    if user.get("id"):
        mycursor.execute(
            "DELETE FROM users WHERE id={user_id}".format(user_id=user_id)
        )
        mydb.commit()
        return {
            "message": "user with id {user_id} is deleted successfully".format(user_id=user_id)
        }
    else:
        return {
            "message": "user with id {user_id} is not exist in users collection".format(user_id=user_id)
        }