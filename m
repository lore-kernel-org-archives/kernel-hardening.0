Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 23 Sep 2016 18:31:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160923173143.GA29830@leverpostej>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
 <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
 <CALCETrWni0aZ71r-R6oYG98kZvZA8a184UR0YURk_=tXu8HXMw@mail.gmail.com>
 <20160916103101.GA21702@leverpostej>
 <CALCETrUDWiDmLbMqw9sQYEzvDuSVfmT_UscxQXfmf8YYyTOC=Q@mail.gmail.com>
 <20160921102827.GC18176@leverpostej>
 <CALCETrV6G2DU1d7qr=ADas7nk5a77=J6X7ezKxw2_kzdmJGDXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV6G2DU1d7qr=ADas7nk5a77=J6X7ezKxw2_kzdmJGDXg@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 2/8] thread_info: allow custom in-task thread_info
To: Andy Lutomirski <luto@amacapital.net>
Cc: james.morse@arm.com, AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, lorenzo.pieralisi@arm.com, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, suzuki.poulose@arm.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 22, 2016 at 03:23:59PM -0700, Andy Lutomirski wrote:
> On Sep 21, 2016 12:28 AM, "Mark Rutland" <mark.rutland@arm.com> wrote:

> > Given all that, can we make the generic thread_info::flags an unsigned
> > long, matching what the thread flag helpers implicitly assume?
> 
> Yes.  Want to send the patch or should I?

I've sent a patch out to LKML [1], though if that doesn't look right I'm
more than happy for you to send a correct one. ;)

Thanks,
Mark.

[1] http://lkml.kernel.org/r/1474651447-30447-1-git-send-email-mark.rutland@arm.com
