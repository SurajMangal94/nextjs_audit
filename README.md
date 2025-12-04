# CISO Assistant Application
A comprehensive Next.js application for security compliance management, built with:

- Next.js 16 - App Router
- TypeScript - Type safety
- Tailwind CSS - Styling
- shadcn/ui - UI Components
- MySQL - Database with multi-tenant support
- JWT Sessions - Authentication
- Custom crypto-based password hashing

## Features
- Multi-tenant/Multi-company architecture
- ISO Audit management
- Gap assessments
- Risk management
- Asset tracking
- Vendor management
- Document management
- Role-based access control
- Comprehensive audit logging

## Getting Started

### Prerequisites
- Node.js 18+
- MySQL 8.0+ database
- pnpm (recommended) or npm

### Installation

#### Quick Start with Automated Installer
The easiest way to set up the application is using the automated install script:

```bash
# Run the installer (uses defaults or environment variables)
./install.sh

# Or customize with environment variables:
DB_HOST=localhost \
DB_USER=root \
DB_PASSWORD=yourpassword \
DB_NAME=ciso_db \
COMPANY_NAME="Your Company" \
ADMIN_EMAIL="admin@yourcompany.com" \
ADMIN_PASSWORD="SecurePass123" \
ADMIN_FIRST_NAME="John" \
ADMIN_LAST_NAME="Doe" \
./install.sh
```

#### Manual Installation
1. Clone the repository
2. Install dependencies:
```bash
pnpm install
```

3. Set up your environment variables - create a `.env.local` file:
```env
# Database Configuration
DB_HOST=127.0.0.1
DB_USER=dbadmin
DB_PASSWORD=yourpassword
DB_NAME=nextjs

# Authentication
SESSION_SECRET=your-super-secret-session-key-change-this

# Application URL
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

4. Set up your database:
```bash
# Create database and import schema
mysql -u root -p -e "CREATE DATABASE nextjs;"
mysql -u root -p nextjs < scripts/01-schema.sql
```

5. Create your first admin user:
```bash
pnpm tsx scripts/create-user.ts "Your Company" "admin@example.com" "password123" "Admin" "User"
```

6. Run the development server:
```bash
pnpm dev
```

7. Open http://localhost:3000 with your browser.

## Project Structure
```
project-root/
├── app/                          # Next.js App Router
│   ├── (auth)/                  # Auth pages (login, signup)
│   ├── api/                     # API routes
│   │   ├── auth/               # Authentication endpoints
│   │   ├── analytics/          # Analytics data
│   │   ├── assessments/        # Gap assessments
│   │   ├── assets/             # Asset management
│   │   ├── audits/             # ISO audits
│   │   ├── risks/              # Risk management
│   │   ├── vendors/            # Vendor management
│   │   └── ...                 # Other endpoints
│   ├── dashboard/              # Dashboard pages
│   │   ├── assessments/        # Gap assessment views
│   │   ├── assets/             # Asset views
│   │   ├── audits/             # Audit views
│   │   ├── risks/              # Risk views
│   │   └── ...                 # Other dashboard pages
│   ├── globals.css             # Global styles
│   ├── layout.tsx              # Root layout
│   └── page.tsx                # Home page
├── components/                  # React components
│   └── ui/                     # shadcn/ui components
├── hooks/                       # Custom React hooks
├── lib/                         # Utility functions
│   ├── auth.ts                 # Authentication & password hashing
│   ├── db.ts                   # Database connection pool
│   ├── session.ts              # JWT session management
│   ├── permissions.ts          # Permission checks
│   └── utils.ts                # Helper functions
├── scripts/                     # Setup scripts
│   ├── 01-schema.sql           # Database schema
│   └── create-user.ts          # User creation script
├── middleware.ts                # Next.js middleware (auth)
├── install.sh                   # Automated installation script
└── ...config files
```

## Database Schema
The application uses a comprehensive multi-tenant schema with the following main tables:
- `companies` - Multi-tenant company data
- `users` - User accounts with company association
- `roles` - Role definitions with permissions
- `iso_audits` - ISO audit tracking
- `gap_assessments` - Compliance gap assessments
- `risks` - Risk management
- `assets` - Asset inventory
- `vendors` - Vendor information
- `documents` - Document management
- `findings` - Audit/assessment findings
- `audit_logs` - Complete audit trail
- `settings` - Application configuration

See `scripts/01-schema.sql` for the complete schema definition.

## Scripts
- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm start` - Start production server
- `pnpm lint` - Run ESLint
- `./install.sh` - Automated installation and setup

## Learn More
- [Next.js Documentation](https://nextjs.org/docs)
- [shadcn/ui](https://ui.shadcn.com)
- [Tailwind CSS](https://tailwindcss.com)

## License
MIT

