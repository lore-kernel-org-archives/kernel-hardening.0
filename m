Date: Fri, 16 Mar 2018 15:38:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] rslib: Remove VLAs by setting upper bound on nroots
Message-Id: <20180316153822.e169251b57165a52494aace7@linux-foundation.org>
In-Reply-To: <20180315225919.GA43806@beast>
References: <20180315225919.GA43806@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Segher Boessenkool <segher@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 15 Mar 2018 15:59:19 -0700 Kees Cook <keescook@chromium.org> wrote:

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

Yeah, email [2] is rather important.  This patch is a bit of a pig to
review!

The restriction to 24 roots might be a significant one, dunno.  Perhaps
we should just kmalloc these things?

Otherwise, RS_MAX_ROOTS becomes part of the rs interface and should be
documented and published in rslib.h?
