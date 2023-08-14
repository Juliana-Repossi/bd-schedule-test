import os
import sys
import random 
from schedule_validator import isValidSchedule

def randomTuple(time):
  optionsTransaction = [1, 2, 3, 4, 5]
  optionsTypeAction = ['R', 'W','R', 'W', 'C','R', 'R', 'W','W', 'A','R', 'W','R', 'W','R', 'W','R', 'W','R', 'W']
  optionsResource = ['A', 'B', 'C', 'D', 'E']

  transaction = random.choice(optionsTransaction)
  action = random.choice(optionsTypeAction)
  
  if action == 'C' or action == 'A':
    resource = '-'
  else:
    resource = random.choice(optionsResource)

  return (time, transaction, action, resource)
  
def generateTrueTest(file):
  file.write('INSERT INTO "Schedule" ("time", "#t", "op", "attr") VALUES\n')

  #geração randomica do tamanho 
  numTransaction = random.randint(3, 20)
  actions = []
  n_inserts = 1

  while n_inserts <= numTransaction:
    line = randomTuple(n_inserts)

    if isValidSchedule(actions + [line]):
      actions += [line]
      file.write(str(line))

      if n_inserts == numTransaction:
        #ultimo
        file.write(';\n')
      else:
        file.write(',\n')
      
      n_inserts += 1
    
def generateFalseTest(file):
  file.write('INSERT INTO "Schedule" ("time", "#t", "op", "attr") VALUES\n')

  #geração randomica do tamanho 
  numTransaction = random.randint(10, 20)
  numTransactionErrorW = random.randint(2, numTransaction - 1)    
  numTransactionError = random.randint(numTransactionErrorW + 1, numTransaction)

  actions = []
  n_inserts = 1

  while n_inserts <= numTransaction:

    if n_inserts == numTransactionErrorW: # inserir correto
      #inserir o block da variável pela transaction
      line = (n_inserts, 6, 'W', 'F')
    elif n_inserts == numTransactionError: # inserir incorreto
      RorW = random.choice(['R', 'W'])
      t = random.choice([1, 2, 3, 4, 5])
      line = (n_inserts, t, RorW, 'F')
    else: # inserir n-2 casos
      line = randomTuple(n_inserts)

    
    actions += [line]
    file.write(str(line))

    if n_inserts == numTransaction:
      #ultimo
      file.write(';\n')
    else:
      file.write(',\n')

    n_inserts += 1

path = os.getcwd() + '/tests'
correctPath = path + '/correct'
incorrectPath = path + '/incorrect'

tests = int(sys.argv[1])

if tests <= 0:
  raise Exception('Number of tests must be a positive integer.')

try:
  os.mkdir(path)
except Exception as e:
  pass

try:
  os.mkdir(correctPath)
except Exception as e:
  pass

try:
  os.mkdir(incorrectPath)
except Exception as e:
  pass

# Generate true cases
for i in range(tests):
  fileName = correctPath + f'/correct{i}.sql'
  file = open(fileName, 'w')
  generateTrueTest(file)
  file.close()

# Generate false cases
for i in range(tests):
  fileName = incorrectPath + f'/incorrect{i}.sql'
  file = open(fileName, 'w')
  generateFalseTest(file)
  file.close()
