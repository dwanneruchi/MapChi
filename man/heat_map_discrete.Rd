% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapping_functions.R
\name{heat_map_discrete}
\alias{heat_map_discrete}
\title{Create a heat map of Chicago with discrete shading.}
\usage{
heat_map_discrete(regions, summary_df, regions_var, fill_var, legend_name,
  palette, lines = "black", title = NULL, title_size = 15)
}
\arguments{
\item{regions}{The type of region to plot. Options include: "CAs", "tracts," "districts,"
and "zips."}

\item{summary_df}{A data frame with summary statistics by region. Should have one row for each
region.}

\item{regions_var}{The variable in summary_df that identifies the region. For example, if type = "CAs"
a common merge_var.y would be "Community.Areas." In general, regions_var should be numeric (e.g. use
community area numbers, not names.).}

\item{fill_var}{The variable that determines color. For example, if the map shows homicides by
police district, the fill_var would be the field that contains homicide totals.}

\item{legend_name}{Self Explanatory. Should be a character vector of length one.}

\item{palette}{The color palette. Current options are: green, blue, red, organge, and purple.}

\item{lines}{Color of border lines. Default is black.}

\item{title}{Title.}

\item{title_size}{Title size.}
}
\value{
A map of Chicago. More specifically, an object of type "ggplot."
}
\description{
Create a heat map of Chicago with discrete shading.
}
\examples{
data(hom_14)
library(dplyr)
hom_sum <- dplyr::summarise(group_by(hom_14, Community.Area), homicides = n())

# No na_replace option for discrete maps. Need to manually add zero homicide CAs.
additions <- c(1:77)[which(!c(1:77) \%in\% hom_sum$Community.Area)]
df_additions <- data.frame(Community.Area = additions, homicides = 0)
hom_sum <- rbind(hom_sum, df_additions)
hom_sum$range <- cut(hom_sum$homicides, c(0, 5, 10, 15, 20, 30, 40),
                     labels = c("0-4", "5-9", "10-14", "15-19",
                               "20-29", "30-39"), right = FALSE)

library(RColorBrewer)
colors <- brewer.pal(n = 6, name = "BuPu")
hm_dis <- heat_map_discrete(regions = "CAs", summary_df = hom_sum, regions_var = "Community.Area",
                            fill_var = "range", legend_name = "Total Homicides",
                            palette = colors, title = "Homicides by Community Area: 2014")
}

