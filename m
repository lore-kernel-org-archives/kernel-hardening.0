MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180419100441.548834519@linutronix.de>
References: <20180419100441.548834519@linutronix.de>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 20 Apr 2018 16:02:23 -0700
Message-ID: <CAGXu5jLs43nUASmLPrKf-eycoYZR3K_vuWi8Q+RaruFfodB0oQ@mail.gmail.com>
Subject: Re: [patch V2 0/8] rslib: Cleanup and VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 19, 2018 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
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
> Changes since V1:
>
>    Simplify error path in the diskonchip code and use the proper
>    function to free the decoder.
>
> As this spawns multiple subsystems it should either go through Andrews tree
> or Kees can route it with his other hardening stuff.

I can start collecting ignored VLA patches. I haven't done that yet as
most maintainers have been taking them. There are only a handful
unapplied. Should I start the tree with rslib? :)

Either way:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
