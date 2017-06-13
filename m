MIME-Version: 1.0
In-Reply-To: <75f33a0f-4643-fe17-fc35-b60b48efd499@samsung.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <CGME20170612170045epcas2p2889350eed8fb2caaa592ef8e6e2c12bf@epcas2p2.samsung.com>
 <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com> <75f33a0f-4643-fe17-fc35-b60b48efd499@samsung.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:47:33 +0200
Message-ID: <CAJHCu1KORP9vKTSRCVNUBP3dfgiL6yg3DDEpuBjPc4r-iA3DEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 19:35 GMT+02:00 Krzysztof Opasiak <k.opasiak@samsung.com>:
> Could you please explain me why we need LSM for this?
>
> There are tools like usbguard[1] and as far as I can tell it looks like they
> can do everything for you...

I have to admit that this is the first time I read about usbguard and it made
me realize that this feature can be implemented in userspace, so no need
to modify the kernel. :)
You are right.

Thank you very much for taking the time to answer me.
