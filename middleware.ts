import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"
import { getCurrentSession } from "./lib/session"

// Routes that don't require authentication
const publicRoutes = ["/login", "/signup", "/api/auth/login", "/api/auth/signup"]

export async function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname

  // Allow public routes
  if (publicRoutes.includes(pathname)) {
    return NextResponse.next()
  }

  // Check for valid session
  const session = await getCurrentSession()

  if (!session) {
    // Redirect to login if no session
    return NextResponse.redirect(new URL("/login", request.url))
  }

  return NextResponse.next()
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|icon\\.svg|apple-icon\\.png).*)"],
}
