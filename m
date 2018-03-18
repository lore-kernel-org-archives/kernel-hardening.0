Date: Sun, 18 Mar 2018 07:48:36 -0500
From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] of: unittest: Remove VLA stack usage
Message-ID: <20180317235304.eohpmrii3htlmann@rob-hp-laptop>
References: <1520828843-22289-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520828843-22289-1-git-send-email-me@tobin.cc>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Frank Rowand <frowand.list@gmail.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 03:27:23PM +1100, Tobin C. Harding wrote:
> The kernel would like to have all stack VLA usage removed[1].  This is a
> test function so the execution speed is not critical.  We can allocate
> memory for this buffer instead of using a VLA.  If kmalloc() fails just
> return.
> 
> Allocate buffer with kmalloc().
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
> 
> Kees is this annoying you, CC'ing you an all my VLA patches?
> 
>  drivers/of/unittest.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Applied.

Rob
