import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = {
  title: 'D2C Management Reports',
  description: 'Multi-client e-commerce and Amazon account management dashboard.'
};
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
