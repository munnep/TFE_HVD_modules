terraform { 
  cloud { 
    hostname = "tfe.patrick-munne.sbx.hashidemos.io" 
    organization = "test" 

    workspaces { 
      name = "test" 
    } 
  } 
}