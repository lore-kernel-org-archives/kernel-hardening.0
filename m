Date: Mon, 12 Mar 2018 16:46:13 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH v2] staging: vchiq_arm: Clear VLA warning
Message-ID: <20180312054613.GG8631@eros>
References: <1520818673-14084-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520818673-14084-1-git-send-email-me@tobin.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Anholt <eric@anholt.net>, Stefan Wahren <stefan.wahren@i2se.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 12:37:53PM +1100, Tobin C. Harding wrote:
> The kernel would like to have all stack VLA usage removed[1].  The array
> here is fixed (declared with a const variable) but it appears like a VLA
> to the compiler.  Also, currently we are putting 768 bytes on the
> stack.  This function is only called on the error path so performance is
> not critical, let's just allocate the memory instead of using the
> stack.  This saves stack space and removes the VLA build warning.
> 
> kmalloc a buffer for dumping state instead of using the stack.
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---

Drop this please, leaks memory.

thanks,
Tobin.
