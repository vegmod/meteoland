\encoding{UTF-8}
\name{weathergeneration}
\alias{weathergeneration}

\title{
Weather generation
}
\description{
A semiparametric multivariate, multisite weather generator. The algorithm can be interpreted as a way to resample the original data to create synthetic data sets of the same length and similar properties.
}
\usage{
weathergeneration(object, params = defaultGenerationParams(), verbose=TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{An object of class \code{\link{SpatialPointsMeteorology-class}}, \code{\link{SpatialGridMeteorology-class}} or \code{\link{SpatialPixelsMeteorology-class}}.}
  \item{params}{A list with parameters for the weather generator (see \code{\link{defaultGenerationParams}}).}
  \item{verbose}{Boolean flag to print process information.}
}
\value{
An object of the same class as the input \code{object}. Generated meteorological series are of the same length as the input.
}
\details{
The implemented algorithm is based on Apipattanavis et al. (2007) for the non-conditional version, and is similar to Steinschneider et al. (2013) for the conditional one. Part of the code was adapted from package 'weathergen' by Jeffrey D. Walker, whom we are grateful. Conditioning is controlled via the element \code{conditional} of \code{params} list, which can be:
\itemize{
\item{\code{"none"} - The non-conditional version is used, which is based on a first order Markov chain (MC) to simulate weather states (dry/wet/extreme wet) and a K-nearest neighbour (KNN) algorithm to select pairs of days with the same transition and similar weather for the initial state (as in Apipattanavis et al. 2007).}
\item{\code{"arima"} - Annual precipitation is conditioned using a stationary auto-regressive (ARIMA) model and then a K-nearest neighbour algorithm is used to select a set of years to train the MC-KNN algorithm (similar to Steinschneider et al. 2013). Recommended if low-frequency variation of annual precipitation is to be acounted for in long series.}
\item{\code{"window"} - The MC-KNN algorithm is trained with the subset of the input data corresponding to a window around the target year. Annual precipitation is conditioned using a lognormal random trial of the precipitation corresponding to the selected years. Recommended to generate stochastic series from climate change projections.}
}
}
\references{
Apipattanavis, S., G. Podesta, B. Rajagopalan, and R. W. Katz (2007), A semiparametric multivariate and multisite weather generator, Water Resour. Res., 43, W11401, doi:10.1029/2006WR005714.

Steinschneider S., and Brown C. (2013) A semiparametric multivariate, multisite weather generator with low-frequency variability for use in climate risk assessments. Water Resour. Res., 49, 7205-7220, doi:10.1002/wrcr.20528.
}
\author{
Miquel De \enc{Cáceres}{Caceres} Ainsa, CREAF
}
\seealso{\code{\link{defaultGenerationParams}}}

\examples{
data(examplegridtopography)
data(exampleinterpolationdata)

#Creates spatial topography points from the grid
p = 1:2
spt = as(examplegridtopography, "SpatialPointsTopography")[p]

#Interpolation of two points for the whole time period (2000-2003)
mp = interpolationpoints(exampleinterpolationdata, spt)

#Plot interpolated meteorological series
meteoplot(mp,1, ylab="Mean temperature")

#Generate a stochastic series using interpolated data as template
y = weathergeneration(mp)

#Plot generated meteorological series
meteoplot(y,1, ylab="Mean temperature")
}
