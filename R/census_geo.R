
#' Geocode a single batch of 1,000 addresses using the Census geocoding api.
#'
#' @param file   A link to a file of up to 1,000 addresses. Addresses must be formattated according to census specifications.
#' For more details see \url{https://www.census.gov/geo/maps-data/data/geocoder.html}. To ensure proper functioning, save
#' your addresses using \code{\link{save_addresses}}.
#'
#' @seealso \code{\link{save_addresses}}
#' @examples census_geo("/path/to/file.txt")
#' @return a data frame with lat/long coordinates for each address that was successfully coded and NA for all others.
#' @export
census_geo <- function (file) {
  for (j in 1:20) {
    x <- httr::POST("https://geocoding.geo.census.gov/geocoder/locations/addressbatch", 
                    body = list(addressFile = httr::upload_file(file), 
                                benchmark = 9, vintage = "Census2010_Census2010"), 
                    encode = "multipart")
    if (x$status_code != 503) {
      break
    }
    print(paste("503 Error #", j))
  }
  
  y <- httr::content(x, encoding = "UTF-8")
  df <- strsplit(y, split = "\\\n")[[1]]
  df <- sapply(df, strsplit, split = ",")
  clean <- lapply(df, length_15)
  
  h   <- t(as.data.frame(clean))
  h   <- as.data.frame(h)
  h[] <- lapply(h, as.character)
  
  both_vars <- c("V1", "V5", "V6", "V7", "V11", "V14", "V15")
  left_vars <- c("V2", "V8", "V12")
  h[, both_vars] <- lapply(h[, both_vars], strip_both)
  h[, left_vars] <- lapply(h[, left_vars], strip_left)
  
  h$V13 <- strip_right(h$V13)
  
  h[] <- lapply(h, stringr::str_trim)
  names(h) <- c("id", "o_address", "o_city", "o_state", "o_zip", "status", "quality", 
                "m_address", "m_city", "m_state", "m_zip", "long", "lat", "not_sure", "L_R")
  
  return(h)
  
}
