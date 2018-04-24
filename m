MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180422162345.004292133@linutronix.de>
References: <20180422162345.004292133@linutronix.de>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Apr 2018 09:42:22 -0700
Message-ID: <CAGXu5jKjV16r3RnrtgTv53xY6tyQmaJ5UQWDLpgk5irr6Mp15A@mail.gmail.com>
Subject: Re: [patch V3 00/10] rslib: Cleanup and VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 22, 2018 at 9:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Kees tried to get rid of the Variable Length Arrays in the Reed-Solomon
> library by replacing them with fixed length arrays on stack. Though they
> are rather large and Andrew did not fall in love with that solution.
>
> This series addresses that in a different way by splitting the rs control
> structure up, so that each invocation of rs_init() returns a new instance
> in which the decoder buffers are allocated. The polynom tables which build
> the base for the RS codecs are still shareable between the instances to
> avoid large allocations and initializations of the same data over and over.
>
> The usage sites have been audited and fixed up where necessary to
> accomodate the decoder change which forbids parallel decoder invocation for
> a particular rs control instance to prevent buffer corruption.
>
> While at it the patch set tidies up the code and converts the related files
> over to use SPDX license identifiers.
>
> Changes since V2:
>
>    Provide a gfp aware variant of init_rs and use it in the alloc callback
>    of the dm/verity_fec rs_pool mempool allocations
>
>    Picked up Reviewed/Acked-by tags and fixed the subject line for the MTD
>    specific patch.

Excellent, thanks!

> Changes since V1:
>
>    Simplify error path in the diskonchip code and use the proper
>    function to free the decoder.
>
> As this spawns multiple subsystems it should either go through Andrews tree
> or Kees can route it with his other hardening stuff.

I'll create a VLA sub-tree to my KSPP stuff and start collecting this
and other VLA fixes that maintainers haven't taken yet. Once
build-testing finishes, I'll push it out for -next.

-Kees

-- 
Kees Cook
Pixel Security
