from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt

Client = MongoClient('mongodb+srv://dheeandressa:dhee.14@cinema.dxxajsg.mongodb.net/?retryWrites=true&w=majority&appName=cinema')
db = Client['test']

@keyword ('limpar user do banco de dados')
def clean_user(user_email):
        users =db['users']
        tasks = db['tasks']
        us= users.find_one({'email':user_email})
        
        if (us):
                tasks.delete_many({'user':us['_id']})
                users.delete_many({'email': user_email})


@keyword ('remover usuario do banco de dados')
def remove_user(email):
        users=db.users
        users.delete_many({'email':email})
        print('removendo o email '+ email)
@keyword ('inserir usuario no banco de dados')
def insert_user(user):
    hash_pass = bcrypt.hashpw(user['password'].encode('utf-8'), bcrypt.gensalt(8))
    doc = {
        'name': user['name'],
        'email': user['email'],
        'password': hash_pass
    }

 
    if 'role' in user:
      
        doc['role'] = user['role']

    users = db['users']
    users.insert_one(doc)