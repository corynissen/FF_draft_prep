
source("get_player_data.R")

uastring <- "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36"
url <- "https://football.fantasysports.yahoo.com/f1/39345"
s <- rvest::html_session(url, httr::user_agent(uastring))  
player_df_list <- get_player_data(session=s, n=100, by_position=TRUE, 
                                  year="2017")
player_df_list2 <- lapply(player_df_list, function(x)x[, c("player_name", "team_abb", "position", "rank_proj", "bye")])
df <- do.call(rbind, player_df_list2)
df$name <- paste(df$player_name, df$team_abb, df$position, sep=" / ")
df <- df[, c("name", "rank_proj", "bye")]

write.csv(df, "data\\players.csv", row.names=FALSE)

qb <- player_df_list[["QB"]]
qb$name <- paste(qb$player_name, qb$team_abb, qb$position, sep=" / ")
qb <- qb[, c("name", "rank_proj", "bye")]
write.csv(qb, "data\\qbs.csv", row.names=FALSE)

wr <- player_df_list[["WR"]]
wr$name <- paste(wr$player_name, wr$team_abb, wr$position, sep=" / ")
wr <- wr[, c("name", "rank_proj", "bye")]
write.csv(wr, "data\\wrs.csv", row.names=FALSE)

rb <- player_df_list[["RB"]]
rb$name <- paste(rb$player_name, rb$team_abb, rb$position, sep=" / ")
rb <- rb[, c("name", "rank_proj", "bye")]
write.csv(rb, "data\\rbs.csv", row.names=FALSE)

te <- player_df_list[["TE"]]
te$name <- paste(te$player_name, te$team_abb, te$position, sep=" / ")
te <- te[, c("name", "rank_proj", "bye")]
write.csv(te, "data\\tes.csv", row.names=FALSE)

def <- player_df_list[["DEF"]]
def$name <- paste(def$player_name, def$team_abb, def$position, sep=" / ")
def <- def[, c("name", "rank_proj", "bye")]
write.csv(def, "data\\defs.csv", row.names=FALSE)

ki <- player_df_list[["K"]]
ki$name <- paste(ki$player_name, ki$team_abb, ki$position, sep=" / ")
ki <- ki[, c("name", "rank_proj", "bye")]
write.csv(ki, "data\\ks.csv", row.names=FALSE)


###
# merge old data with new
# old data imported into excel via archive link once each for each team
old <- read.csv("data/rosters_2016.csv", stringsAsFactors=FALSE)
old$keeper_2016 <- substring(old$player, nchar(old$player)) == "?"
old$player <- trimws(gsub("\\?", "", old$player))

new <- list()
new$qb <- read.csv("data\\qbs.csv", stringsAsFactors=FALSE)
new$wr <- read.csv("data\\wrs.csv", stringsAsFactors=FALSE)
new$te <- read.csv("data\\tes.csv", stringsAsFactors=FALSE)
new$rb <- read.csv("data\\rbs.csv", stringsAsFactors=FALSE)
df <- do.call("rbind", new)
df$only_name <- trimws(substring(df$name, 1, (regexpr("/", df$name)-2)))
old <- merge(old, df, by.x="player", by.y="only_name", all.x=TRUE)
old <- old[, c("player", "fan_pts", "owner", "keeper_2016", "name", 
               "rank_proj")]
names(old) <- c("name", "fan_pts_2016", "owner_2016","keeper_2016", 
                "name", "rank_proj_2017")
write.csv(old, "data\\2016_rosters.csv", row.names=FALSE)

