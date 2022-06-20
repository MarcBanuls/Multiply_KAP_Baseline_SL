library(redcapAPI)
library(stringr)
library(dplyr)
library(tidyr)
source("tokens.R")
api.url <- maternal_api
#togo_bl_token
api.token <- sl_kap_token
rcon <- redcapConnection(api.url, api.token)

my.fields <- c('record_id', 'id_cap')

data <- data.frame()

data <- exportRecords(
  rcon,
  factors = F,
  fields = my.fields,
  form_complete_auto = F
  
)

data_clean<- separate(data,'id_cap', sep = '-', into = c('kap','slb','hf','id'),remove = FALSE, fill = 'left')
data_clean$hf_id <- paste(data_clean$hf,data_clean$id, sep = '-')

#duplicates?
n_occur <- data.frame(table(data_clean$hf_id))
n_occur[n_occur$Freq > 1,]
