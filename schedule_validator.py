def isValidSchedule(schedule):
  lockResources = {}

  for action in schedule:
    time, transaction, typeAction, resource = action

    if typeAction == 'R' or typeAction == 'W': # Read or Write
      if resource in lockResources:
        if transaction != lockResources[resource]:
          return False
      elif typeAction == 'W':
        lockResources[resource] = transaction
    
    elif typeAction == 'C' or typeAction == 'A': # Commit or Abort
      for key, value in lockResources.copy().items():
        if value == transaction:
          lockResources.pop(key)

    else:
      raise Exception("Invalid Type!")

  return True
