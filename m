Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 11:32:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161027103143.GB27135@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476802761-24340-1-git-send-email-colin@cvidal.org>
Subject: Re: [kernel-hardening] [RFC 0/2] arm: implementation of
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Oct 18, 2016 at 04:59:19PM +0200, Colin Vidal wrote:
> Hi,
> 
> This is the first attempt of HARDENED_ATOMIC port to arm arch.

As a general note, please Cc relevant lists and people, as per
get_maintainer.pl. For these patches that should tell you to Cc
linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, and
a number of people familiar with the atomics.

Even if things are far from perfect, and people don't reply (or reply
but not too kindly), having them on Cc earlier makes it far more likely
that issues are spotted and addressed earlier, minimizes repeatedly
discussing the same issues, and also minimizes the potential for future
arguments about these things being developed in isolation.

Unless you do that, critical review for core code and arch code will
come very late, and that could potentially delay this being merged for a
very long time, which would be unfortunate.

> About the fault handling I have some questions (perhaps some arm
> expert are reading?):
> 
>    - As the process that made the overflow is killed, the kernel will
>      not try to go to a fixup address when the exception is raised,
>      right ? Therefore, is still mandatory to add an entry in the
>      __extable section?
> 
>    - In do_PrefetchAbort, I am unsure the code that follow the call to
>      hardened_atomic_overflow is needed: the process will be killed
>      anyways.

Unfortunately, I'm only somewhat familiar with the ARM atomics, and I
have absolutely no familiarity with the existing PaX patchset.

For both of these, some background rationale would be helpful. e.g. what
does the fixup entry do? When is it invoked?

I'll see what I can reverse-engineer from the patches.

> I take some freedom compared to PaX patch, especially by adding some
> macro to expand functions in arm/include/asm/atomic.h.
> 
> The first patch is the modification I have done is generic part to
> make it work.

If you're relying on a prior patch series, please refer to that in the
cover, to make it possible for reviewers to find.

If you have a public git repo, placing this in a branch (or a tagged
commit), and referring to that in the cover messages would make it much
easier for people to review and/or test.

Thanks,
Mark.
