MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LRH.2.20.1702131625430.8914@namei.org>
References: <alpine.LRH.2.20.1702131625430.8914@namei.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 09:51:28 -0800
Message-ID: <CAGXu5jL418kOXVhoYg8DoMdVDZm4e93rH16cOS_feMjkxrpD2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 0/4] ro hardening for the security subsystem
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 12, 2017 at 9:31 PM, James Morris <jmorris@namei.org> wrote:
> Hi Folks,
>
> Please review/test these patches which add some read-only hardening to the
> security subsystem.
>
> In this series, the following are marked as __ro_after_init:
>
> - LSM hooks
> - Netfilter hooks used by security/
> - the default IMA rules
>
> I've also constified the SELinux Netlink permission tables, which will
> ensure they're located in an RO section.

A lot of the security subsystem is targeted during kernel write
exploits, so I think this is very nice change to have. Thanks for
doing this!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
