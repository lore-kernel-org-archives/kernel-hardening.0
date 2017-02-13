MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com>
References: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 10:21:13 -0800
Message-ID: <CAGXu5j+iJ2nGoqok7deER_QnedPFjZ5Qb+ja4VnkPqnNL=vTcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] usercopy: add testcases to check zeroing on failure of usercopy
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2017 at 10:13 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> In the hardend usercopy, the destination buffer will be zeroed if
> copy_from_user/get_user fails. This patch adds testcases for it.
> The destination buffer is set with non-zero value before illegal
> copy_from_user/get_user is executed and the buffer is compared to
> zero after usercopy is done.
>
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>

This looks great!

I'll adjust the commit slightly (the zeroing always happens,
regardless of hardened usercopy) and add it to my usercopy tree.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
