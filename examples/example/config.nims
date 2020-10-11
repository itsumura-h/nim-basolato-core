import os
# DB Connection
putEnv("DB_DRIVER", "postgres")
putEnv("DB_CONNECTION", "postgres:5432")
putEnv("DB_USER", "user")
putEnv("DB_PASSWORD", "Password!")
putEnv("DB_DATABASE", "allographer")
# Logging
putEnv("LOG_IS_DISPLAY", "true")
putEnv("LOG_IS_FILE", "true")
putEnv("LOG_DIR", "/root/project/examples/example/logs")
# Security
putEnv("SECRET_KEY", "8^)QD&_&*e>8VJ>dvpc=YB=2") # 24 length
putEnv("CSRF_TIME", "525600") # minutes of 1 year
putEnv("SESSION_TIME", "20160") # minutes of 2 weeks
putEnv("SESSION_DB", "/root/project/examples/example/session.db")
putEnv("IS_SESSION_MEMORY", "false")
