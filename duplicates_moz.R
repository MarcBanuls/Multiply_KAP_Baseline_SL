library(redcapAPI)
library(stringr)
library(dplyr)
library(tidyr)
source("tokens.R")
api.url <- maternal_api
#moz_bl_token
api.token <- moz_kap_token
rcon <- redcapConnection(api.url, api.token)

my.fields <- c('record_id', 'id_cap')

data <- data.frame()

data <- exportRecords(
  rcon,
  factors = F,
  fields = my.fields,
  form_complete_auto = F
  
)

####
# Remove DEC entries (--1 and --2) and keep only merged entries
data <- data[!grepl('--1', data$record_id),]
data <- data[!grepl('--2', data$record_id), ]

###
#which(duplicated(data$record_id))
#data_test <- data[grepl('LS', data$id_cap), ]

data_clean<- separate(data,'record_id', sep = '-', into = c(NA,'kap','ps','multiply','f1','moz','massinga','hf'),remove = FALSE, fill = 'left')
data_clean$hf_idcap <- paste(data_clean$hf,data_clean$id_cap, sep = '-')
which(duplicated(data_clean$hf_idcap))

#duplicates?
n_occur <- data.frame(table(data_clean$hf_id))
n_occur[n_occur$Freq > 1,]
