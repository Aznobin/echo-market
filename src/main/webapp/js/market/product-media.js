(() => {
    for (const image of document.querySelectorAll('.product-media img')) {
        const fallback = () => {
            image.hidden = true;
            const label = image.parentElement.querySelector('.photo-empty');
            if (label) label.hidden = false;
        };
        image.addEventListener('error', fallback, { once: true });
        if (image.complete && image.naturalWidth === 0) fallback();
    }
    const input = document.getElementById('product-photo');
    if (!input) return;
    const photo = document.getElementById('photo-preview');
    const hint = document.getElementById('photo-hint');
    let url;
    input.addEventListener('change', () => {
        if (url) URL.revokeObjectURL(url);
        const file = input.files[0];
        url = file?.type.startsWith('image/') ? URL.createObjectURL(file) : null;
        photo.hidden = true;
        hint.hidden = false;
        hint.textContent = '选择照片后可查看预览';
        if (url) photo.src = url;
        else photo.removeAttribute('src');
    });
    photo.addEventListener('load', () => { if (url) { photo.hidden = false; hint.hidden = true; } });
    photo.addEventListener('error', () => { photo.hidden = true; hint.hidden = false; hint.textContent = '无法预览这张照片'; });
})();
