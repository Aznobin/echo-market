(() => {
    'use strict';
    const key = 'echo-market.theme';
    const root = document.documentElement;
    try {
        if (localStorage.getItem(key) === 'dark') root.dataset.theme = 'dark';
    } catch { /* A storage restriction must not prevent using the page. */ }

    document.addEventListener('DOMContentLoaded', () => {
        const button = document.getElementById('theme-toggle');
        if (!button) return;
        const icon = button.querySelector('span');
        const sync = () => {
            const dark = root.dataset.theme === 'dark';
            const label = dark ? '切换亮色主题' : '切换暗色主题';
            button.setAttribute('aria-label', label);
            button.setAttribute('aria-pressed', String(dark));
            button.title = label;
            icon.textContent = dark ? '☀' : '☾';
        };
        button.addEventListener('click', () => {
            root.dataset.theme = root.dataset.theme === 'dark' ? 'light' : 'dark';
            try { localStorage.setItem(key, root.dataset.theme); } catch { /* Keep the current page usable. */ }
            sync();
        });
        sync();
        button.hidden = false;
    });
})();
