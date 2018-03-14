Date: Wed, 14 Mar 2018 18:03:41 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] vgacon: fix function prototypes
Message-ID: <20180314170341.GA15364@kroah.com>
References: <20180310064059.12720-1-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180310064059.12720-1-jmoreira@suse.de>
To: Joao Moreira <jmoreira@suse.de>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, danielmicay@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 03:40:59AM -0300, Joao Moreira wrote:
> It is possible to indirectly invoke functions with prototypes that do not
> match those of the respectively used function pointers by using void types.
> Despite widely used as a feature for relaxing function invocation, this
> should be avoided when possible as it may prevent the use of heuristics
> such as prototype matching-based Control-Flow Integrity, which can be used
> to prevent ROP-based attacks.
> 
> Given the above, the current efforts to improve the Linux security, and the
> upcoming kernel support to compilers with CFI features, fix prototypes in
> vgacon console driver.
> 
> Another similar fix can be seen in [1].
> 
> [1] https://android-review.googlesource.com/c/kernel/common/+/602010
> 
> Signed-off-by: João Moreira <jmoreira@suse.de>
> Acked-by: Kees Cook <keescook@chromium.org>
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/video/console/vgacon.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

This fails the build :(

drivers/video/console/vgacon.c:1432:15: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .con_putcs = vgacon_putcs,
               ^~~~~~~~~~~~

What tree should this go to?  It doesn't apply at all to my tty tree,
which is where I thought it should go, so I tried a different one and
got this mess :(

confused,

greg k-h
