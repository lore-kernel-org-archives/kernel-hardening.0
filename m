MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <151571799008.27429.12325141216769795517.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571799008.27429.12325141216769795517.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 12 Jan 2018 11:38:58 +0100
Message-ID: <CAMuHMdXXB0GxbzV2YR9yvp=DhgXnbm2QRFQzQ+tJ46dG9feC-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 01/19] Documentation: document array_ptr
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Linux-Arch <linux-arch@vger.kernel.org>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Dan,

On Fri, Jan 12, 2018 at 1:46 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Mark Rutland <mark.rutland@arm.com>
>
> Document the rationale and usage of the new array_ptr() helper.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks for the update!

> --- /dev/null
> +++ b/Documentation/speculation.txt
> @@ -0,0 +1,142 @@
> +This document explains potential effects of speculation, and how undesirable
> +effects can be mitigated portably using common APIs.
> +
> +===========
> +Speculation
> +===========
> +
> +To improve performance and minimize average latencies, many contemporary CPUs
> +employ speculative execution techniques such as branch prediction, performing
> +work which may be discarded at a later stage.
> +
> +Typically speculative execution cannot be observed from architectural state,
> +such as the contents of registers. However, in some cases it is possible to
> +observe its impact on microarchitectural state, such as the presence or
> +absence of data in caches. Such state may form side-channels which can be
> +observed to extract secret information.
> +
> +For example, in the presence of branch prediction, it is possible for bounds
> +checks to be ignored by code which is speculatively executed. Consider the
> +following code:
> +
> +       int load_array(int *array, unsigned int idx) {

One more opening curly brace to move to the next line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
