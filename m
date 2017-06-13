MIME-Version: 1.0
In-Reply-To: <8219df49-321d-d032-48b5-cf1cd5a46664@schaufler-ca.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com> <8219df49-321d-d032-48b5-cf1cd5a46664@schaufler-ca.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:51:24 +0200
Message-ID: <CAJHCu1+5x47b8Dz6F7DdoX7dDGKOT8g-LGYmGb3GV_4CTqBjLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 23:31 GMT+02:00 Casey Schaufler <casey@schaufler-ca.com>:
> Return the error reported by the hook rather than -EPERM.

Agreed, anyway this part will be, probably, dropped in
the next version (read Greg and Krzysztof answers).
I'm sorry :(

Thank you very much for the time you spent on this.
