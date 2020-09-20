
window.klaroConfig = {
    elementID: 'klaro',
    storageMethod: 'localStorage',
    storageName: 'klaro',
    htmlTexts: true,
    cookieExpiresAfterDays: 30,
    privacyPolicy: {en: '/cookies-policy.html'},
    default: true,
    mustConsent: true,
    acceptAll: true,
    hideDeclineAll: false,
    hideLearnMore: false,
    translations: {
        en: {
            purposes: {
                essential: 'Essential',
                analytics: 'Analytics (know which pages are read)',
                security: 'Security',
                livechat: 'Livechat',
                advertising: 'Advertising',
                styling: 'Styling',
            },
        }
    },    
    apps: [
        {
            name: 'google-analytics',
            default: true,
            title: 'Google Analytics',
            purposes: ['analytics'],
            cookies: [/^ga/i],
            callback: function(consent, app) {
            },
            required: false,
            optOut: false,
            onlyOnce: true,
        },
        {
            name: 'cloudflare',
            title: 'Cloudflare',
            purposes: ['security'],
            required: true
        },
        {
            name: 'codepen',
            title: 'codepen.io',
            purposes: ['styling'],
            required: true
        },
        {
            name: 'googleFonts',
            title: 'Google Fonts',
            purposes: ['styling'],
            required: true
        },
    ],
};