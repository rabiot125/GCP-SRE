provider "google" {
  credentials = file("credentials.json")
  project     = "sre-interview-app"
  region      = "us-central1"
}

resource "google_sql_database_instance" "instance" {
  name             = "mysql-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "messages_db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "user" {
  name     = "root"
  instance = google_sql_database_instance.instance.name
  password = "root"
}

resource "google_cloud_run_service" "service" {
  name     = "backend-service"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/sre-interview-app/backend"
        env {
          name  = "MYSQL_HOST"
          value = google_sql_database_instance.instance.ip_address[0].ip_address
        }
        env {
          name  = "MYSQL_USER"
          value = google_sql_user.user.name
        }
        env {
          name  = "MYSQL_PASSWORD"
          value = google_sql_user.user.password
        }
        env {
          name  = "MYSQL_DB"
          value = google_sql_database.database.name
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  service = google_cloud_run_service.service.id
  role    = "roles/run.invoker"
  member  = "allUsers"
}

resource "google_cloud_run_service" "frontend" {
  name     = "frontend-service"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/sre-interview-app/frontend"
        env {
          name  = "REACT_APP_BACKEND_URL"
          value = "https://${google_cloud_run_service.service.status[0].url}"
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "frontend_invoker" {
  service = google_cloud_run_service.frontend.id
  role    = "roles/run.invoker"
  member  = "allUsers"
}
