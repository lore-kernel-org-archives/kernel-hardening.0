Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161027110742.GD27135@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-3-git-send-email-colin@cvidal.org> <20161025091807.GX19531@linaro.org>
 <1477407767.2263.22.camel@cvidal.org> <20161026072423.GB19531@linaro.org>
 <1477470016.2263.87.camel@cvidal.org> <20161027110742.GD27135@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Oct 2016 14:37:34 -0700
Message-ID: <CAGXu5jJx-c4zENdrQ0bJrKEGVAiWthutsgDtkGBeA4wSwgw=pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC 2/2] arm: implementation for HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 4:08 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Oct 26, 2016 at 10:20:16AM +0200, Colin Vidal wrote:
> Given it looks like there's at least one necessary round of bikeshedding, it
> would be best to discuss this with the usual atomic maintainers included, so as
> to avoid several more rounds over subsequent postings. i.e.
>
> [mark@leverpostej:~/src/linux]% ./scripts/get_maintainer.pl -f \
>         include/asm-generic/atomic.h \
>         include/asm-generic/atomic-long.h \
>         include/linux/atomic.h
> Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/ASM HEADER FILES)
> Ingo Molnar <mingo@kernel.org> (commit_signer:8/11=73%)
> Peter Zijlstra <peterz@infradead.org> (commit_signer:6/11=55%,authored:5/11=45%,added_lines:491/671=73%,removed_lines:186/225=83%)
> Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:3/11=27%,authored:3/11=27%,added_lines:42/671=6%,removed_lines:21/225=9%)
> Boqun Feng <boqun.feng@gmail.com> (commit_signer:1/11=9%,authored:1/11=9%)
> Chris Metcalf <cmetcalf@ezchip.com> (commit_signer:1/11=9%)
> Davidlohr Bueso <dave@stgolabs.net> (authored:1/11=9%,added_lines:128/671=19%)
> linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES)
> linux-kernel@vger.kernel.org (open list)

Yeah, I'll be bringing the hardened atomic patch up during kernel
summit, but I think the RFC has gotten to the point where we need to
loop in more maintainers.

Thanks!

-Kees

-- 
Kees Cook
Nexus Security
