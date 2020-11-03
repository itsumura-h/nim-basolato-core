import os
# DB Connection
putEnv("DB_DRIVER", "postgres")
putEnv("DB_CONNECTION", "postgres:5432")
putEnv("DB_USER", "user")
putEnv("DB_PASSWORD", "Password!")
putEnv("DB_DATABASE", "allographer")
putEnv("DB_MAX_CONNECTION", "95")
# Logging
# putEnv("LOG_IS_DISPLAY", "true")
# putEnv("LOG_IS_FILE", "true")
putEnv("LOG_IS_DISPLAY", "false")
putEnv("LOG_IS_FILE", "false")
putEnv("LOG_DIR", "/root/project/benchmark/basolato/logs")
# Security
putEnv("SECRET_KEY", "df@mRJ-%?l4+ngtUc~V-kPY+") # 24 length
putEnv("CSRF_TIME", "525600") # minutes of 1 year
putEnv("SESSION_TIME", "20160") # minutes of 2 weeks
putEnv("SESSION_DB", "/root/project/benchmark/basolato/session.db")
putEnv("IS_SESSION_MEMORY", "false")
