<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;
use Symfony\Component\HttpFoundation\Request; // ✅ Correct import

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
            // ✅ Trust Render's HTTPS proxy
            Request::setTrustedProxies(
                ['0.0.0.0/0'],
                Request::HEADER_X_FORWARDED_ALL
            );

            // ✅ Force all URLs and forms to use HTTPS
            URL::forceScheme('https');
        }
    }
}
