 {
     backends: [ 'statsd-elasticsearch-backend'],
     debug: true,
     flushInterval: 30000,
     elasticsearch: {
         port:          {{ELASTICSEARCH_PORT}},
         host:          "{{ELASTICSEARCH_ADDRESS}}",
         path:          "/",
         indexPrefix:   "statsd",
         //indexTimestamp: "year",  //for index statsd-2015
         //indexTimestamp: "month", //for index statsd-2015.01
         indexTimestamp: "day",     //for index statsd-2015.01.01
         countType:     "counter",
         timerType:     "timer",
         timerDataType: "timer_data",
         gaugeDataType: "gauge",
         formatter:     "default_format"
     }
}