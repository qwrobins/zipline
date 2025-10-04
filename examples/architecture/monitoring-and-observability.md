# Monitoring and Observability

## Monitoring Stack

- **Frontend Monitoring:** Vercel Analytics (Web Vitals tracking)
- **Error Tracking:** React Error Boundaries + console logging (sufficient for MVP per PRD)
- **Performance Monitoring:** Lighthouse CI in GitHub Actions
- **User Interaction Tracking:** None (privacy-focused MVP; no analytics tracking)

## Key Metrics

**Frontend Metrics:**
- **Core Web Vitals:**
  - LCP (Largest Contentful Paint): Target < 2.5s
  - FID (First Input Delay): Target < 100ms
  - CLS (Cumulative Layout Shift): Target < 0.1
- **JavaScript Errors:** Caught by error boundaries, logged to console
- **API Response Times:** Monitored via Network tab in dev; React Query DevTools in development
- **Bundle Size:** Monitored via Next.js build output

**Operational Metrics:**
- Build success rate (GitHub Actions)
- Test pass rate (CI pipeline)
- Deployment frequency (Vercel dashboard)
- Preview deployment success rate

---
