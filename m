MIME-Version: 1.0
In-Reply-To: <20170620070721.GA30728@amd>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-5-git-send-email-s.mesoraca16@gmail.com> <20170620070721.GA30728@amd>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 20 Jun 2017 09:53:37 +0200
Message-ID: <CAJHCu1KujgnTsyRBRCk2LXFFdRZKWVRHmdV3nPPiUanXsLq=sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 04/11] S.A.R.A. USB Filtering
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-20 9:07 GMT+02:00 Pavel Machek <pavel@ucw.cz>:
> Hmm. Given that USB device provides vendor id/product id, this does
> not really stop anyone, right?
>
> AFAICT you can still get USB stick with vid/pid of logitech keyboard,
> and kernel will recognize it as a usb stick.

There are a number of ways by which a device can be assigned to a driver.
vid/pid is the most common for the most esoteric devices: i.e. less used/most
dangerous.
However you are right, a final version of this feature should have included
"interface matching" too and even something much more specific like serial
matching.
Anyway, because of lack of interest in having this feature included in kernel
space (something similar can already be done in user-space) it has been
abandoned.
You are answering to an old version of S.A.R.A. that can now be considered
obsolete.
Thank you anyway for your comment.

Salvatore
