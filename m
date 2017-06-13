MIME-Version: 1.0
In-Reply-To: <20170612193826.GA4235@kroah.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-4-git-send-email-s.mesoraca16@gmail.com> <20170612193826.GA4235@kroah.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:50:06 +0200
Message-ID: <CAJHCu1+P798ip7qMTdu6SrKnSg4+0kFzyQb1gqGT31ih5atGKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 03/11] Creation of "usb_device_auth" LSM hook
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-usb@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 21:38 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> No, like Krzysztof said, you can already do this today, just fine, from
> userspace.  I think that support has been there for over a decade now,
> why are you not taking advantage of this already?
> No need to add extra stuff to the kernel at all to do this

Honesty, now that you mention it, I agree with you.
This feature can be implemented in userspace and I'm the first one to
think that what can be implemented in userspace should stay in
userspace.

> sorry you
> implemented all of this for no reason :(

Don't worry, usb filtering is just a small part of this patchset.
Let's hope the rest will end up being more useful. :)

Thank you very much for taking the time to answer me.
