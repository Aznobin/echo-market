(() => {
    const form = document.getElementById('register-form');
    if (!form) return;
    const password = form.elements.namedItem('password');
    const confirm = form.elements.namedItem('confirmPassword');
    const match = () => confirm.setCustomValidity(!confirm.value || password.value === confirm.value ? '' : '两次输入的密码不一致');
    password.addEventListener('input', match);
    confirm.addEventListener('input', match);
    form.addEventListener('submit', event => {
        match();
        if (!confirm.reportValidity()) event.preventDefault();
    });
})();
