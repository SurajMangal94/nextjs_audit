#!/bin/bash
set -x

# --- CISO Assistant Installer ---

echo "Welcome to the CISO Assistant Installer!"
echo "This script will automatically set up your application."
echo "Set environment variables to customize: DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, COMPANY_NAME, ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_FIRST_NAME, ADMIN_LAST_NAME"
echo ""

# --- Helper Functions ---
print_error() {
  echo "❌ Error: $1" >&2
  exit 1
}

print_success() {
  echo "✅ $1"
}

print_warning() {
  echo "⚠️  Warning: $1"
}

# --- 1. Prerequisites Check ---
echo "--- Step 1: Checking prerequisites ---"
if ! command -v pnpm &> /dev/null; then
  print_error "pnpm is not installed. Please install it first (e.g., 'npm install -g pnpm')."
fi
print_success "pnpm is installed."

if ! command -v mysql &> /dev/null; then
  print_error "mysql client is not installed. Please install it first."
fi
print_success "mysql client is installed."
echo ""

# --- 2. Load Database Configuration from Environment or .env.local ---
echo "--- Step 2: Loading Configuration ---"

# Try to load from .env.local if it exists
if [ -f .env.local ]; then
  print_warning "Found existing .env.local file, loading configuration from it..."
  source .env.local
fi

# Use environment variables or defaults
DB_HOST=${DB_HOST:-127.0.0.1}
DB_USER=${DB_USER:-dbadmin}
DB_PASSWORD=${DB_PASSWORD:-Welkom022}
DB_NAME=${DB_NAME:-nextjs}
COMPANY_NAME=${COMPANY_NAME:-"Default Company"}
ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@example.com"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"Admin123456"}
ADMIN_FIRST_NAME=${ADMIN_FIRST_NAME:-"Admin"}
ADMIN_LAST_NAME=${ADMIN_LAST_NAME:-"User"}

echo "Using configuration:"
echo "  DB_HOST: ${DB_HOST}"
echo "  DB_USER: ${DB_USER}"
echo "  DB_NAME: ${DB_NAME}"
echo "  COMPANY_NAME: ${COMPANY_NAME}"
echo "  ADMIN_EMAIL: ${ADMIN_EMAIL}"
echo "  ADMIN_FIRST_NAME: ${ADMIN_FIRST_NAME}"
echo "  ADMIN_LAST_NAME: ${ADMIN_LAST_NAME}"
echo ""

# --- 3. Generate Session Secret & .env file ---
echo "--- Step 3: Generating Environment File ---"
SESSION_SECRET=$(openssl rand -hex 32)

cat > .env.local << EOL
# --- Database Configuration ---
DB_HOST=${DB_HOST}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME}

# --- Authentication ---
SESSION_SECRET=${SESSION_SECRET}

# --- Application URL ---
NEXT_PUBLIC_APP_URL=http://localhost:3000
EOL

print_success ".env.local file created."
echo ""

# --- 4. Verify Tailwind CSS v4 Configuration ---
echo "--- Step 4: Verifying Tailwind CSS v4 Configuration ---"
if [ ! -f "postcss.config.mjs" ]; then
  print_error "postcss.config.mjs not found. This file is required for Tailwind CSS v4."
fi

if [ ! -f "tailwind.config.ts" ]; then
  print_error "tailwind.config.ts not found. This file is required for Tailwind CSS configuration."
fi

if [ ! -f "app/globals.css" ]; then
  print_error "app/globals.css not found. This file is required for Tailwind CSS styles."
fi

# Verify postcss.config.mjs contains @tailwindcss/postcss
if ! grep -q "@tailwindcss/postcss" postcss.config.mjs; then
  print_warning "postcss.config.mjs may not be configured for Tailwind CSS v4. Expected '@tailwindcss/postcss' plugin."
fi

# Verify globals.css uses the new v4 import syntax
if ! grep -q "@import.*tailwindcss" app/globals.css; then
  print_warning "app/globals.css may not use Tailwind CSS v4 syntax. Expected '@import \"tailwindcss\"' or '@import 'tailwindcss''."
fi

print_success "Tailwind CSS v4 configuration files verified."
echo ""

# --- 5. Install Dependencies ---
echo "--- Step 5: Installing Dependencies ---"
if ! pnpm install; then
  print_error "Failed to install dependencies with pnpm."
fi
print_success "Dependencies installed."
echo ""

# --- 6. Database Setup ---
echo "--- Step 6: Setting up the Database ---"
echo "Attempting to connect to MySQL and set up the database..."

# Check connection and create database

mysql -h"${DB_HOST}" -u"${DB_USER}" --password="${DB_PASSWORD}" -e "DROP DATABASE IF EXISTS \`${DB_NAME}\`;" 2> /dev/null

if ! mysql -h"${DB_HOST}" -u"${DB_USER}" --password="${DB_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" 2> mysql_error.log; then

    echo "MySQL error log:"

    cat mysql_error.log

    rm mysql_error.log

    print_error "Could not connect to MySQL or create database. Please check your credentials."

fi

print_success "Database '${DB_NAME}' created or already exists."



# Populate schema

if ! mysql -h"${DB_HOST}" -u"${DB_USER}" --password="${DB_PASSWORD}" "${DB_NAME}" < scripts/01-schema.sql 2> mysql_error.log; then

    echo "MySQL error log:"

    cat mysql_error.log

    rm mysql_error.log

    print_error "Failed to import the database schema from 'scripts/01-schema.sql'."

fi
print_success "Database schema imported successfully."
echo ""


# --- 7. Create First User ---
echo "--- Step 7: Creating Admin Account ---"
echo "Creating company '${COMPANY_NAME}' and admin user '${ADMIN_EMAIL}'..."

if ! DB_HOST="${DB_HOST}" DB_USER="${DB_USER}" DB_PASSWORD="${DB_PASSWORD}" DB_NAME="${DB_NAME}" pnpm tsx scripts/create-user.ts "${COMPANY_NAME}" "${ADMIN_EMAIL}" "${ADMIN_PASSWORD}" "${ADMIN_FIRST_NAME}" "${ADMIN_LAST_NAME}"; then
  print_error "Failed to create the admin user."
fi

print_success "Admin user created successfully."
echo ""


# --- 8. Final Instructions ---
echo "--- Installation Complete! ---"
echo ""
print_success "Your CISO Assistant application is ready to go!"
echo ""
echo "This application uses:"
echo "  - Next.js 16 with App Router"
echo "  - Tailwind CSS v4 (configured with @tailwindcss/postcss)"
echo "  - TypeScript"
echo "  - MySQL database"
echo ""
echo "You can start the development server with:"
echo ""
echo "  pnpm dev"
echo ""
echo "Then, open your browser to http://localhost:3000 and log in with:"
echo "  Email: ${ADMIN_EMAIL}"
echo "  Password: [the password you entered]"
echo ""
echo "Note: If you encounter any Tailwind CSS styling issues, ensure that:"
echo "  - app/globals.css uses '@import \"tailwindcss\"' (v4 syntax)"
echo "  - postcss.config.mjs uses '@tailwindcss/postcss' plugin"
echo "  - tailwind.config.ts is properly configured"
echo ""