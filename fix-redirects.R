existing_posts <- fs::dir_ls(path = here::here("docs", "posts"), recurse = TRUE, glob = "*.html")

posts <- existing_posts[grepl("posts", x = existing_posts)]


old_location <- stringr::str_remove(dirname(existing_posts), "Users/michael/dewitt_blog/docs/")
new_location <- paste0("programming", stringr::str_remove(dirname(existing_posts), "Users/michael/dewitt_blog/docs/posts/"))

new_location<-stringr::str_remove(new_location, "_files")

new_text <- glue::glue('
<!DOCTYPE html>
<meta charset="utf-8">
<title>Redirecting to https://michaeldewittjr.com/{new_location}</title>
<meta http-equiv="refresh" content="0; URL=https://michaeldewittjr.com/{new_location}/">
<link rel="canonical" href="https://michaeldewittjr.com/">
')


for(i in seq_along(existing_posts)){
  writeLines(text = new_text[i], con = existing_posts[i] )
}

new_location <- c("index.html", "about.html")

new_text <- glue::glue('
<!DOCTYPE html>
<meta charset="utf-8">
<title>Redirecting to https://michaeldewittjr.com/{new_location}</title>
<meta http-equiv="refresh" content="0; URL=https://michaeldewittjr.com/{new_location}/">
<link rel="canonical" href="https://michaeldewittjr.com/">
')

existing_posts <- sprintf("docs/%s", c("index.html", "about.html"))

for(i in seq_along(existing_posts)){
  writeLines(text = new_text[i], con = existing_posts[i] )
}
