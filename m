Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RESEND] rsi: Remove stack VLA usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520819022-15238-1-git-send-email-me@tobin.cc>
References: <1520819022-15238-1-git-send-email-me@tobin.cc>
Message-Id: <20180313165207.BB0FE600C1@smtp.codeaurora.org>
Date: Tue, 13 Mar 2018 16:52:07 +0000 (UTC)
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

"Tobin C. Harding" <me@tobin.cc> wrote:

> The kernel would like to have all stack VLA usage removed[1].  rsi uses
> a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
> is defined using a magic number.  We can use a pre-processor defined
> constant and declare the array to maximum size.  We add a check before
> accessing the array in case of programmer error.
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

There were conflicts. Can you rebase on top of wireless-drivers-next and
resend, please?

Recorded preimage for 'drivers/net/wireless/rsi/rsi_91x_sdio.c'
error: Failed to merge in the changes.
Applying: rsi: Remove stack VLA usage
Using index info to reconstruct a base tree...
M	drivers/net/wireless/rsi/rsi_91x_hal.c
M	drivers/net/wireless/rsi/rsi_91x_sdio.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/rsi/rsi_91x_sdio.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rsi/rsi_91x_sdio.c
Auto-merging drivers/net/wireless/rsi/rsi_91x_hal.c
Patch failed at 0001 rsi: Remove stack VLA usage
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10274983/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
