#!/bin/bash

# This script helps setting up the project based on the README.md file.

# Exit immediately if a command exits with a non-zero status.
set -e

# 1. Check for pnpm
if ! command -v pnpm &> /dev/null
then
    echo "pnpm could not be found. Please install it first."
    echo "You can install it by running: npm install -g pnpm"
    exit 1
fi

# 2. Install dependencies
echo "Installing dependencies using pnpm..."
pnpm install

# 3. Set up environment variables
echo "Creating .env.local file..."
if [ -f ".env.local" ]; then
    echo ".env.local already exists. Skipping creation."
else
    cat > .env.local << EOL
DATABASE_URL=mysql://user:password@localhost:3306/database_name
SESSION_SECRET=your-super-secret-session-key-change-this
NEXT_PUBLIC_APP_URL=http://localhost:3000
EOL
    echo ".env.local created successfully."
fi

# 4. Database setup instructions
echo ""
echo "--------------------------------------------------"
echo "Project setup is almost complete!"
echo "Next steps:"
echo ""
echo "1. Edit the .env.local file and replace the placeholder values with your MySQL database credentials."
echo ""
echo "2. Connect to your MySQL server and run the following command to create the database (replace 'database_name' with your actual database name):"
echo "   CREATE DATABASE database_name;"
echo ""
echo "3. Use the newly created database:"
echo "   USE database_name;"
echo ""
echo "4. Run the SQL script to create the tables:"
echo "   source scripts/01-schema.sql"
echo ""
echo "   Alternatively, you can pipe the file to your mysql client:"
echo "   mysql -u your_user -p your_database < scripts/01-schema.sql"
echo ""
echo "5. After setting up the database, you can run the development server with:"
echo "   pnpm dev"
echo ""
echo "--------------------------------------------------"

