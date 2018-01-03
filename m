Date: Wed, 3 Jan 2018 15:28:49 +0100 (CET)
From: Geo Kozey <geokozey@mailfence.com>
Message-ID: <1660505746.8419.1514989729607@ichabod.co-bxl>
In-Reply-To: <20180103072652.161912-1-mahesh@bandewar.net>
References: <20180103072652.161912-1-mahesh@bandewar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCHv4 1/2] capability: introduce sysctl
 for controlled user-ns capability whitelist
To: Mahesh Bandewar <mahesh@bandewar.net>
Cc: Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux Security <linux-security-module@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

> From: Mahesh Bandewar <maheshb@google.com>
> 
> The default value set (for kernel.controlled_userns_caps_whitelist) is
> CAP_FULL_SET indicating that no capability is controlled by default to
> maintain compatibility with the existing behavior of user-ns. Administrator
> will have to modify this sysctl to control any capability as such. e.g. to
> control CAP_NET_RAW the mask need to be changed like -
> 
>   # sysctl -q kernel.controlled_userns_caps_whitelist
>   kernel.controlled_userns_caps_whitelist = 1f,ffffffff
>   # sysctl -w kernel.controlled_userns_caps_whitelist=1f,ffffdfff
>   kernel.controlled_userns_caps_whitelist = 1f,ffffdfff
> 
> For bit-to-mask conversion please check include/uapi/linux/capability.h
> file.

Is it possible to make those sysctl values human readable? That would make
admins life easier.

Yours sincerely

G. K.
