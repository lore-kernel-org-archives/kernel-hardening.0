Date: Mon, 12 Mar 2018 08:00:24 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] rsi: Remove stack VLA usage
Message-ID: <20180311210024.GF16734@eros>
References: <1520577493-24603-1-git-send-email-me@tobin.cc>
 <87r2ota625.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r2ota625.fsf@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 12:37:06PM +0200, Kalle Valo wrote:
> "Tobin C. Harding" <me@tobin.cc> writes:
> 
> > The kernel would like to have all stack VLA usage removed[1].  rsi uses
> > a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
> > is defined using a magic number.  We can use a pre-processor defined
> > constant and declare the array to maximum size.  We add a check before
> > accessing the array in case of programmer error.
> >
> > [1]: https://lkml.org/lkml/2018/3/7/621
> >
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> 
> Please CC linux-wireless list, otherwise patchwork won't see the patch
> and I can't apply it.

No worries Kelle can do, will repost as [RESEND]

thanks,
Tobin.
