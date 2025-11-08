<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;
use Symfony\Component\HttpFoundation\Request;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (config('app.env') === 'production') {
            // ✅ Trust all proxies for Render
            Request::setTrustedProxies(
                ['0.0.0.0/0'],
                Request::HEADER_X_FORWARDED_PROTO // ✅ only use PROTO
            );

            // ✅ Force all routes and assets to use HTTPS
            URL::forceScheme('https');
        }
    }
}
