Date: Thu, 15 Mar 2018 22:27:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rslib: Remove VLAs by setting upper bound on nroots
In-Reply-To: <20180310223450.GA37999@beast>
Message-ID: <alpine.DEB.2.21.1803152226590.1520@nanos.tec.linutronix.de>
References: <20180310223450.GA37999@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Segher Boessenkool <segher@kernel.crashing.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 10 Mar 2018, Kees Cook wrote:

> Avoid stack VLAs[1] by always allocating the upper bound of stack space
> needed. The existing users of rslib appear to max out at 24 roots[2],
> so use that as the upper bound until we have a reason to change it.
> 
> Alternative considered: make init_rs() a true caller-instance and
> pre-allocate the workspaces. This would possibly need locking and
> a refactoring of the returned structure.
> 
> Using kmalloc in this path doesn't look great, especially since at
> least one caller (pstore) is sensitive to allocations during rslib
> usage (it expects to run it during an Oops, for example).
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> [2] https://lkml.org/lkml/2018/3/9/838
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
