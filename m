Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
References: <1343143742-31229-1-git-send-email-tixxdz@opendz.org>
Date: Tue, 24 Jul 2012 10:41:06 -0700
Message-ID: <CAGXu5jJTJ2uz-GGCXhHtUnGiZy=ChXVWYey8d2XTa4gZjJ7w2w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 0/2] proc: /proc/<pid>/environ offset fixes
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>, David Rientjes <rientjes@google.com>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Jul 24, 2012 at 8:29 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> This is the V2 to correctly check offsets on /proc/<pid>/environ before
> reading. This was previously discussed here:
> http://lkml.org/lkml/2012/7/22/79
>
> Due to incorrect offset checks, currently one can read from aribtrary
> addresses on /proc/<pid>/environ, not only the environment address range
> as shown here (the same thread):
> http://lkml.org/lkml/2012/7/22/163
>
> The bug is in environ_read().
> [...]
> Djalal Harouni (2):
>   proc: environ_read() make sure offset points to environment address range
>   proc: do not allow negative offsets on /proc/<pid>/environ
>
>  fs/proc/base.c |   22 +++++++++++++---------
>   1 files changed, 13 insertions(+), 9 deletions(-)

This looks good, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
