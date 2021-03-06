\encoding{UTF-8}
\name{MeteorologyInterpolationData}
\alias{MeteorologyInterpolationData}
\title{
Creates an object of class 'MeteorologyInterpolationData'
}
\description{
Initializes an object for meteorology interpolation over landscapes using weather station data and the methods described in Thornton et al. (1997) and Thornton & Running (1999).
}
\usage{
MeteorologyInterpolationData(points, elevation = NULL, slope = NULL, aspect = NULL,
                             MinTemperature = NULL, MaxTemperature = NULL,
                             Precipitation = NULL, RelativeHumidity = NULL,
                             Radiation = NULL, WindSpeed = NULL,
                             WindDirection = NULL, WindFields = NULL,
                             params = defaultInterpolationParams())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{points}{An object of class \code{\link{SpatialPointsMeteorology}}, an object of \code{\link{SpatialPointsTopography}} or an object of class \code{\link{SpatialPoints}} (see 'Details'').}
  \item{elevation}{A numeric vector with elevation values of weather stations (in meters).}
  \item{slope}{A numeric vector with slope values of weather stations (in degrees). Needed for cross-validation of interpolation routines.}
  \item{aspect}{A numeric vector with aspect values of weather stations (in degrees from North). Needed for cross-validation of interpolation routines.}
  \item{MinTemperature}{A matrix with minimum temperature recordings (in degrees Celsius) for all weather stations (in rows) and all days (in columns). }
  \item{MaxTemperature}{A matrix with maximum temperature recordings (in degrees Celsius) for all weather stations (in rows) and all days (in columns).  }
  \item{Precipitation}{A matrix with precipitation recordings (in mm of water) for all weather stations (in rows) and all days (in columns).}
  \item{RelativeHumidity}{A matrix with (mean) relative humidity recordings (in percent) for all weather stations (in rows) and all days (in columns). }
  \item{Radiation}{A matrix with relative radiation recordings (in MJ/m2) for all weather stations (in rows) and all days (in columns). Needed for cross-validation only.}
  \item{WindSpeed}{A matrix with wind speed recordings (in m/s) for all weather stations (in rows) and all days (in columns). }
  \item{WindDirection}{A matrix with wind direction recordings (in degrees from North) for all weather stations (in rows) and all days (in columns). }
  \item{WindFields}{Object of class \code{"list"}. See function \code{\link{readWindNinjaWindFields}}.}
  \item{params}{A list containing interpolation parameters. }
}
\details{
There are three ways of building an object of \code{\linkS4class{MeteorologyInterpolationData}}:
\enumerate{
\item{The first way is using an object of \code{\linkS4class{SpatialPointsMeteorology}} containing both the coordinates and meteorological series of stations. In this case \code{elevation} has to be provided, but \code{aspect} and \code{slope} may be ommitted. Parameters \code{MinTemperature} to \code{WindDirection} can be left as \code{NULL}.}
\item{The second way is using an object of class of \code{\link{SpatialPointsTopography}} containing the coordinates of stations and topographic variables. In this case  parameters \code{MinTemperature} and  \code{MaxTemperature} will need to be supplied, each being a matrix with weather stations in rows and days in columns, but \code{Precipitation}, \code{RelativeHumidity}, \code{Radiation}, \code{WindSpeed} and \code{WindDirection} may be left as \code{NULL}.}
\item{The third way is using an object of \code{\link{SpatialPoints}} containing the coordinates of stations only. In this case \code{elevation} has to be provided, but \code{aspect} and \code{slope} may be ommitted. As in the second case, parameters \code{MinTemperature} and \code{MaxTemperature}   will need to be supplied, each being a matrix with weather stations in rows and days in columns, but other variables may be left as \code{NULL}.}
}
}
\value{
An object of class \code{\linkS4class{MeteorologyInterpolationData}}.
}
\references{
Thornton, P.E., Running, S.W., 1999. An improved algorithm for estimating incident daily solar radiation from measurements of temperature, humidity, and precipitation. Agric. For. Meteorol. 93, 211–228. doi:10.1016/S0168-1923(98)00126-9.

Thornton, P.E., Running, S.W., White, M. a., 1997. Generating surfaces of daily meteorological variables over large regions of complex terrain. J. Hydrol. 190, 214–251. doi:10.1016/S0022-1694(96)03128-9.
}
\author{
Miquel De \enc{Cáceres}{Caceres} Ainsa, CREAF
}

\seealso{
\code{\linkS4class{MeteorologyInterpolationData}}, \code{\link{defaultInterpolationParams}}.
}
\examples{
## TO BE DONE ##
}
