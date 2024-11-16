# GCP-SRE# Frontend and Backend Deployment on Google Cloud Platform

## Overview

This project demonstrates how to deploy a React frontend and a Flask backend to Google Cloud Platform (GCP), using Cloud Run and Terraform. A MySQL database is used to store messages.

## Prerequisites

- Google Cloud Platform account
- Docker installed
- Terraform installed
- Google Cloud SDK installed
- Bitbucket account for CI/CD integration

## Setup Instructions

### 1. Backend Service

#### Build and Push Docker Image

### 2. Frontend Service

docker build -t gcr.io/sre-interview-app/frontend-service:v.1.0.0 .

docker push gcr.io/sre-interview-app/frontend-service:v.1.0.0 