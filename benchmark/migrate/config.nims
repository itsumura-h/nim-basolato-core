import os
# DB Connection
putEnv("DB_DRIVER", "postgres")
putEnv("DB_CONNECTION", "postgres:5432")
putEnv("DB_USER", "user")
putEnv("DB_PASSWORD", "Password!")
putEnv("DB_DATABASE", "allographer")
putEnv("DB_MAX_CONNECTION", "95")
