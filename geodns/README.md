# GeoDNS راهنما

GeoDNS یعنی DNS سرور بر اساس موقعیت جغرافیایی کاربر، آی‌پی‌های مختلف برگردونه.

## گزینه‌ها

| سرویس | GeoDNS واقعی | رایگان | سادگی |
|-------|-------------|--------|-------|
| [AWS Route53](route53/setup.md) | ✅ | ❌ (~$1/ماه) | متوسط |
| [Cloudflare LB](cloudflare/setup.md) | ✅ | ❌ (پولی) | ساده |
| [Cloudflare Workers](cloudflare/setup.md) | شبیه‌سازی | ✅ (محدود) | متوسط |
| NS1 | ✅ | ✅ (تا 500k query) | متوسط |

## توصیه

برای پروداکشن: **AWS Route53** با Health Check.

برای تست سریع: **Cloudflare Workers**.
