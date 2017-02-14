MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LRH.2.20.1702150003580.29914@namei.org>
References: <alpine.LRH.2.20.1702150003580.29914@namei.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 14 Feb 2017 09:21:23 -0800
Message-ID: <CAGXu5jLHzvL_ryFYZJjLJ8qVEWS+yLHW-nK+SKFt2GwNorvjeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 0/2] security: mark LSM hooks
 with __ro_after_init
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 5:15 AM, James Morris <jmorris@namei.org> wrote:
> Updated and simplified down to two patches.
>
> Following feedback from the list, I've added a new config option to handle
> the case where SELinux still needs to disable its hooks at runtime (and
> thus the hooks must be writable in that case).
>
> I've dropped the Netfilter hooks patch as I realized that the hook ops
> list structures could be modified after init by the core NF code.
>
> The SELinux Netlink message patch has been merged, and Mimi is reviewing
> the IMA default policy patch (it's not affected by LSM hook requirements
> and can be merged separately).
>
> ---
>
> James Morris (2):
>   security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
>   security: mark LSM hooks as __ro_after_init

Please consider these both:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
