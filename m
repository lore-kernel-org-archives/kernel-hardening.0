Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] rsi: Remove stack VLA usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521081085-16404-1-git-send-email-me@tobin.cc>
References: <1521081085-16404-1-git-send-email-me@tobin.cc>
Message-Id: <20180327080453.5F80E60588@smtp.codeaurora.org>
Date: Tue, 27 Mar 2018 08:04:53 +0000 (UTC)
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Larry Finger <Larry.Finger@lwfinger.net>
List-ID: <kernel-hardening.lists.openwall.com>

"Tobin C. Harding" <me@tobin.cc> wrote:

> The use of stack Variable Length Arrays needs to be avoided, as they
> can be a vector for stack exhaustion, which can be both a runtime bug
> (kernel Oops) or a security flaw (overwriting memory beyond the
> stack). Also, in general, as code evolves it is easy to lose track of
> how big a VLA can get. Thus, we can end up having runtime failures
> that are hard to debug. As part of the directive[1] to remove all VLAs
> from the kernel, and build with -Wvla.
> 
> Currently rsi code uses a VLA based on a function argument to
> `rsi_sdio_load_data_master_write()`.  The function call chain is
> 
> Both these functions
> 
> 	rsi_sdio_reinit_device()
> 	rsi_probe()
> 
> start the call chain:
> 
> 	rsi_hal_device_init()
> 	rsi_load_fw()
> 	auto_fw_upgrade()
> 	ping_pong_write()
> 	rsi_sdio_load_data_master_write()
> 
> [Without familiarity with the code] it appears that none of the 4 locks
> 
> 	mutex
> 	rx_mutex
> 	tx_mutex
> 	tx_bus_mutex
> 
> are held when `rsi_sdio_load_data_master_write()` is called.  It is therefore
> safe to use kmalloc with GFP_KERNEL.
> 
> We can avoid using the VLA by using `kmalloc()` and free'ing the memory on all
> exit paths.
> 
> Change buffer from 'u8 array' to 'u8 *'.  Call `kmalloc()` to allocate memory for
> the buffer.  Using goto statement to call `kfree()` on all return paths.
> 
> It can be expected that this patch will result in a small increase in overhead
> due to the use of `kmalloc()` however this code is only called on initialization
> (and re-initialization) so this overhead should not degrade performance.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Patch applied to wireless-drivers-next.git, thanks.

44f98a9332e4 rsi: Remove stack VLA usage

-- 
https://patchwork.kernel.org/patch/10283841/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
