import { init as initApm } from "@elastic/apm-rum";

initApm({
  // Set required service name (allowed characters: a-z, A-Z, 0-9, -, _, and space)
  serviceName: "Supplejack Manager",

  // Set custom APM Server URL (default: http://localhost:8200)
  serverUrl: process.env.ELASTIC_APM_SERVER_URL,

  // Set service version (required for sourcemap feature)
  serviceVersion: "",

  environment: process.env.NODE_ENV,
  active: false /* process.env.RAILS_ENV == "production" */,
});
