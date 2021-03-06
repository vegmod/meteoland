\encoding{UTF-8}
\name{interpolation.cv}
\alias{interpolation.cv}
\alias{interpolation.calibration}
\alias{interpolation.calibration.fmax}
\alias{summary.interpolation.cv}
\alias{plot.interpolation.cv}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calibration and validation of interpolation procedures
}
\description{
Function \code{interpolation.calibration} determines optimal interpolation parameters 'N' and 'alpha' for a given meteorological variable. Optimization is done by minimizing mean absolute error (MAE) (Thornton et al. 1997). Function \code{interpolation.cv} calculates average mean absolute errors (MAE) for the prediction period of an object of class '\code{MeteorologyInterpolationData}'.  Function \code{summary.interpolation.cv} returns a data.frame with cross-validation  summaries and \code{plot.interpolation.cv} plots cross-validation results. In both calibration and validation procedures, predictions for each weather station are made using a leave-one-out procedure (i.e. after excluding the station from the predictive set).
}
\usage{
interpolation.calibration(object, stations = NULL, variable="Tmin",
                        N_seq = seq(5,30, by=5), alpha_seq = seq(0.25,10, by=0.25),
                        verbose = FALSE)
interpolation.calibration.fmax(object, stations = NULL, 
                               fmax_seq = seq(0.05,0.95, by=0.05), 
                               verbose = FALSE)                        
interpolation.cv(object, stations = NULL, verbose = FALSE)
\S3method{summary}{interpolation.cv}(object, ...)
\S3method{plot}{interpolation.cv}(x, type = "stations", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{In the case of function \code{interpolation.cv}, an object of class \code{\link{MeteorologyInterpolationData-class}}. In the case of function \code{summary}, an object of class \code{\link{interpolation.cv}}}
  \item{stations}{A numeric vector containing the indices of stations to be used to calculate mean absolute errors (MAE) in the calibration or cross-validation analysis. All the stations with data are included in the training set but predictive MAE are calculated for the 'stations' subset only.}
  \item{variable}{A string indicating the meteorological variable for which interpolation parameters 'N' and 'alpha' will be calibrated. Accepted values are 'Tmin' (for minimum temperature), 'Tmax' (for maximum temperature), 'Tdew' (for dew-point temperature), 'PrecEvent' (for precipitation events),'PrecAmount' (for regression of precipitation amounts),'Prec' (for precipitation with the same values for precipitation events and regression of precipitation amounts).}
  \item{N_seq}{Set of average number of points to be tested.}
  \item{alpha_seq}{Set of alpha values to be tested.}
  \item{fmax_seq}{Set of f_max values to be tested.}
  \item{verbose}{A logical flag to generate additional console output.}
  \item{x}{A S3 object of class \code{interpolation.cv} with cross-validation results.}
  \item{type}{A string of the plot type to be produced (either "stations" or "dates").}
  \item{...}{Additional parameters passed to summary and plot functions.}
}
\value{
Function \code{interpolation.calibration} returns an object of class \code{'interpolation.calibration'}  with the following items:
\itemize{
\item{\code{MAE}: A numeric matrix with the mean absolute error values (averaged across stations) for each combination of parameters 'N' and 'alpha'.}
\item{\code{minMAE}: Minimum MAE value.}
\item{\code{N}: Value of parameter 'N' corresponding to the minimum MAE.}
\item{\code{alpha}: Value of parameter 'alpha' corresponding to the minimum MAE.}
\item{\code{Observed}: A matrix with observed values.}
\item{\code{Predicted}: A matrix with predicted values for the optimum parameter combination.}
}
Function \code{interpolation.cv} returns a list of class \code{'interpolation.cv'} with the following items:
\itemize{
\item{\code{stations}: A data frame with as many rows as weather stations and the following columns:
\itemize{
\item{\code{MinTemperature-Bias}: Bias (in degrees), calculated over the prediction period, of minimum temperature estimations in weather stations.}
\item{\code{MinTemperature-MAE}: Mean absolute errors (in degrees), averaged over the prediction period, of minimum temperature estimations in weather stations.}
\item{\code{MaxTemperature-Bias}: Bias (in degrees), calculated over the prediction period, of maximum temperature estimations in weather stations.}
\item{\code{MaxTemperature-MAE}: Mean absolute errors (in degrees), averaged over the prediction period, of maximum temperature estimations in weather stations.}
\item{\code{Precipitation-Total}: Difference in the total precipitation of the studied period.}
\item{\code{Precipitation-DPD}: Difference in the proportion of days with precipitation.}
\item{\code{Precipitation-Bias}: Bias (in mm), calculated over the days with precipitation, of precipitation amount estimations in weather stations.}
\item{\code{Precipitation-MAE}: Mean absolute errors (in mm), averaged over the days with precipitation, of precipitation amount estimations in weather stations.}
\item{\code{RelativeHumidity-Bias}: Bias (in percent), calculated over the prediction period, of relative humidity estimations in weather stations.}
\item{\code{RelativeHumidity-MAE}: Mean absolute errors (in percent), averaged over the prediction period, of relative humidity estimations in weather stations.}
\item{\code{Radiation-Bias}: Bias (in MJ/m2), calculated over the prediction period, of incoming radiation estimations in weather stations.}
\item{\code{Radiation-MAE}: Mean absolute errors (in MJ/m2), averaged over the prediction period, of incoming radiation estimations in weather stations.}
}
}
\item{\code{dates}: A data frame with as many rows as weather stations and the following columns:
\itemize{
\item{\code{MinTemperature-Bias}: Daily bias (in degrees), averaged over the stations, of minimum temperature estimations.}
\item{\code{MinTemperature-MAE}: Daily mean absolute error (in degrees), averaged over the stations, of minimum temperature estimations.}
\item{\code{MaxTemperature-Bias}: Daily bias (in degrees), averaged over the stations, of maximum temperature estimations.}
\item{\code{MaxTemperature-MAE}: Daily mean absolute error (in degrees), averaged over the stations, of maximum temperature estimations.}
\item{\code{Precipitation-Bias}: Daily bias (in mm), averaged over the stations, of precipitation amount estimations.}
\item{\code{Precipitation-MAE}: Daily mean absolute error (in mm), averaged over the stations, of precipitation amount estimations.}
\item{\code{RelativeHumidity-Bias}: Daily bias (in percent), averaged over the stations, of relative humidity estimations.}
\item{\code{RelativeHumidity-MAE}: Daily mean absolute error (in percent), averaged over the stations, of relative humidity estimations.}
\item{\code{Radiation-Bias}: Daily bias (in MJ/m2), averaged over the stations, of incoming radiation estimations.}
\item{\code{Radiation-MAE}: Daily mean absolute errors (in MJ/m2), averaged over the stations, of incoming radiation estimations.}
}
}
\item{\code{MinTemperature}: A data frame with predicted minimum temperature values.}
\item{\code{MinTemperatureError}: A matrix with predicted minimum temperature errors.}
\item{\code{MaxTemperature}: A data frame with predicted maximum temperature values.}
\item{\code{MaxTemperatureError}: A matrix with predicted maximum temperature errors.}
\item{\code{Precipitation}: A data frame with predicted precipitation values.}
\item{\code{PrecipitationError}: A matrix with predicted precipitation errors.}
\item{\code{RelativeHumidity}: A data frame with predicted relative humidity values.}
\item{\code{RelativeHumidityError}: A matrix with predicted relative humidity errors.}
\item{\code{Radiation}: A data frame with predicted radiation values.}
\item{\code{RadiationError}: A matrix with predicted radiation errors.}
}
}
\references{
Thornton, P.E., Running, S.W., 1999. An improved algorithm for estimating incident daily solar radiation from measurements of temperature, humidity, and precipitation. Agric. For. Meteorol. 93, 211–228. doi:10.1016/S0168-1923(98)00126-9.

De Caceres M, Martin-StPaul N, Turco M, Cabon A, Granda V (2018) Estimating daily meteorological data and downscaling climate models over landscapes. Environmental Modelling and Software 108: 186-196.
}
\author{
Miquel De \enc{Cáceres}{Caceres} Ainsa, CREAF
}
\seealso{\code{\link{MeteorologyInterpolationData}}}

\examples{
data(exampleinterpolationdata)

#Calibration procedure
precEv_cal = interpolation.calibration(exampleinterpolationdata, variable="PrecEvent",
                                       stations = 1:5,
                                       N_seq=c(5,10,15), alpha_seq=seq(0.25,1.0, by=0.25),
                                       verbose = TRUE)

precAm_cal = interpolation.calibration(exampleinterpolationdata, variable="PrecAmount",
                                       stations = 1:5,
                                       N_seq=c(5,10,15), alpha_seq=seq(0.25,1.0, by=0.25),
                                       verbose = TRUE)

#Set 'alpha' and 'N' parameters to values found in calibration
exampleinterpolationdata@params$N_PrecipitationEvent = precEv_cal$N
exampleinterpolationdata@params$alpha_PrecipitationEvent = precEv_cal$alpha

exampleinterpolationdata@params$N_PrecipitationAmount = precAm_cal$N
exampleinterpolationdata@params$alpha_PrecipitationAmount = precAm_cal$alpha

#Run cross validation
cv = interpolation.cv(exampleinterpolationdata, stations = 1:5, verbose = TRUE)

#Print cross validation summaries
summary(cv)

#Plot results
plot(cv)
}
