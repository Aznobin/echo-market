(() => {
  'use strict';
    const users = {
      xiaoman: { username: 'xiaoman', nickname: '小满', admin: true },
      yan: { username: 'yan', nickname: '晚自习的阿言' },
      he: { username: 'he', nickname: '小何同学' },
      lin: { username: 'lin', nickname: '林间' },
      tang: { username: 'tang', nickname: '糖炒栗子' },
    };
    const categories = ['教材书籍', '电子数码', '生活用品', '服饰鞋包', '运动器材', '美妆个护', '其他闲置'];
    const photos = {
      headphones: './images/market/headphones.jpg', camera: './images/market/camera.jpg',
      books: './images/market/books.jpg', sneakers: './images/market/sneakers.jpg',
      lamp: './images/market/lamp.jpg', bicycle: './images/market/bicycle.jpg',
      bag: './images/market/bag.jpg', laptop: './images/HUAWEI_MateBook_14.png',
      illustration: './images/115411842_p0.jpg',
    };
    const product = (id, title, price, categoryId, image, seller, description, sold = false) => ({ id, title, price, categoryId, image: photos[image], kind: image, seller, description, sold });
    const createData = () => ({
      me: 'xiaoman', accounts: {},
      products: [
        product('101', '头戴式无线耳机', 159, 2, 'headphones', 'yan', '耳罩和头梁无破损，附充电线。可以在图书馆门口先试听再决定。'),
        product('102', '索尼微单相机', 680, 2, 'camera', 'he', '日常拍社团活动用的相机，快门和显示正常。想要看样片可以先私信我。'),
        product('103', '课外阅读闲置书 · 一组', 36, 1, 'books', 'lin', '换宿舍想给书架腾点地方。书页没有破损，有几本有少量铅笔批注。'),
        product('104', '轻便跑鞋 · 42 码', 120, 4, 'sneakers', 'tang', '只在操场穿过几次，鞋底磨损轻微。适合日常走路或短距离慢跑。'),
        product('105', '宿舍桌面台灯', 35, 3, 'lamp', 'lin', '可调整照明角度，开关正常。搬宿舍前出，竹园楼下自提。'),
        product('106', '校内通勤自行车', 260, 5, 'bicycle', 'he', '上课代步用，刹车和车铃正常。可以在操场外试骑。'),
        product('107', '日常通勤双肩包', 58, 4, 'bag', 'tang', '夹层能放 14 寸电脑，拉链完好。可在食堂门口交接。'),
        product('108', 'HUAWEI MateBook 14 鸿蒙版', 3200, 2, 'laptop', 'yan', '14 寸笔记本，含适配器。样图为原项目素材，成色请以面交验机为准。'),
        product('109', '初音主题明信片', 12, 7, 'illustration', 'xiaoman', '社团交换留存的主题卡，校内当面交接。', true),
        product('110', '室友转出的阅读灯', 23, 3, 'lamp', 'lin', '在宿舍用了一学期，已校内面交。', true),
        product('111', '红色运动鞋 · 41 码', 80, 4, 'sneakers', 'xiaoman', '样板中用于展示买家付款后、卖家待发货的订单。', true),
      ],
      favorites: { xiaoman: ['101', '104'] },
      threads: [
        { owner: 'xiaoman', productId: '101', other: 'yan', unread: true, items: [
          { from: 'xiaoman', text: '请问耳机还在吗？周三傍晚能面交吗？', time: '昨天 18:20' },
          { from: 'yan', text: '还在。可以呀，六点在图书馆门口见？你可以先试一下。', time: '昨天 18:26' },
        ] },
        { owner: 'xiaoman', productId: '105', other: 'lin', unread: false, items: [
          { from: 'lin', text: '台灯可以在竹园楼下交接，出门前给我发条消息就好。', time: '昨天 16:40' },
        ] },
      ],
      orders: [
        { id: '26001', productId: '110', buyer: 'xiaoman', seller: 'lin', amount: 23, status: 3, deliveryType: 'meetup', payMethod: 'cod', receiverName: '小满', phone: '演示号码', address: '竹园一号楼', remark: '', time: '11 月 20 日 18:26' },
        { id: '26002', productId: '111', buyer: 'tang', seller: 'xiaoman', amount: 80, status: 1, deliveryType: 'dorm', payMethod: 'online', receiverName: '糖炒栗子', phone: '演示号码', address: '竹园三号楼', remark: '请先在站内联系。', time: '11 月 21 日 15:52' },
        { id: '26003', productId: '109', buyer: 'he', seller: 'xiaoman', amount: 12, status: 3, deliveryType: 'meetup', payMethod: 'cod', receiverName: '小何同学', phone: '演示号码', address: '南食堂门口', remark: '', time: '11 月 21 日 12:30' },
      ],
      ratings: [
        { orderId: '26001', from: 'lin', to: 'xiaoman', score: 5, content: '按约定时间到的，沟通很顺畅。', time: '11 月 20 日' },
        { orderId: '26003', from: 'he', to: 'xiaoman', score: 5, content: '明信片保存得很好，谢谢！', time: '11 月 21 日' },
      ],
      reports: [
        { id: '601', from: 'he', targetType: 2, targetId: '103', reason: '希望补充书页细节图，方便判断批注情况。', status: 0, time: '11 月 20 日' },
        { id: '602', from: 'xiaoman', targetType: 2, targetId: '105', reason: '希望确认台灯的实际交接地点。', status: 1, time: '11 月 21 日' },
      ],
    });
    window.EchoPreviewFixtures = Object.freeze({ users, categories, createData });
})();
