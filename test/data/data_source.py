import addressbook_pb2
import sys

person = addressbook_pb2.Person()
person.id = 1234
person.name = "John Doe"
person.email = "jdoe@example.com"
phone = person.phone.add()
phone.number = "555-4321"
phone.type = addressbook_pb2.Person.HOME

f = open('data.bin', 'wb')
f.write(person.SerializeToString())
f.close()
