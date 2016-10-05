Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 5 Oct 2016 20:43:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161005194354.GA26546@remoulade>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
Subject: [kernel-hardening] Re: initcall randomization
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On Wed, Oct 05, 2016 at 06:09:01PM +0100, Ard Biesheuvel wrote:
> Did anyone ever look into whether there is anything to gain in terms
> of hardening from randomizing the order initcalls are issued at each
> level? I know entropy is hard to come by at this stage, but on recent
> UEFI systems, this is something we could potentially solve
> generically. (It may uncover some breakage as well, but only hidden
> breakage that could already surface at any time due to linker changes,
> so I think this could serve as a diagnostic option as well)

As a stress-testing/debugging feature, this would certainly be useful.

>From a hardening PoV, I can't immediately see what this would gain us.

Also, if we ever solve probe dependencies, I suspect that will remove a lot of
scope for re-ordering.

> Since boot time mappings are often performed in initcalls, this could
> potentially reduce the predictability of the layout of the virtual
> kernel space.

Given you say 'mappings', I assume you mean {io,mem}remap() and friends. If we
have the entropy to randomize the initcalls, can't we use that to randomize the
VAs of those mappings? Or is this for the early allocators where that is
trickier?

For general allocations there's the freelist randomization, though I believe
that the order is predictable at boot time, per the commit message for
210e7a43fa905bcc ("mm: SLUB freelist randomization").

Thanks,
Mark.
