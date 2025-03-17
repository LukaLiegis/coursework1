
models <- list(Basic=model, Multiplicative=model_mult, Flexible=model_flexible)
results_metrics <- data.frame(Model=character(), RMSE=numeric(), MAPE=numeric())

for (name in names(models)) {
    m <- models[[name]]
    future_cv <- make_future_dataframe(m, periods=12, freq="month")
    forecast_cv <- predict(m, future_cv)
    forecast_values <- tail(forecast_cv$yhat, 12)
    rmse_val <- sqrt(mean((forecast_values - actual_values)^2))
    mape_val <- 100 * mean(abs((forecast_values - actual_values) / actual_values))
    results_metrics <- rbind(results_metrics, data.frame(Model=name, RMSE=rmse_val, MAPE=mape_val))
}

knitr::kable(results_metrics, digits=3)



last_date <- tail(forecast$ds, 1)
last_value <- tail(forecast$yhat, 1)