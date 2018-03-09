From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] rsi: Remove stack VLA usage
References: <1520577493-24603-1-git-send-email-me@tobin.cc>
Date: Fri, 09 Mar 2018 12:37:06 +0200
In-Reply-To: <1520577493-24603-1-git-send-email-me@tobin.cc> (Tobin C.
	Harding's message of "Fri, 9 Mar 2018 17:38:13 +1100")
Message-ID: <87r2ota625.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

"Tobin C. Harding" <me@tobin.cc> writes:

> The kernel would like to have all stack VLA usage removed[1].  rsi uses
> a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
> is defined using a magic number.  We can use a pre-processor defined
> constant and declare the array to maximum size.  We add a check before
> accessing the array in case of programmer error.
>
> [1]: https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Please CC linux-wireless list, otherwise patchwork won't see the patch
and I can't apply it.

-- 
Kalle Valo
