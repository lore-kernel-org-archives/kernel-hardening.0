Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 10 Dec 2015 23:38:25 +0100
MIME-Version: 1.0
Message-ID: <5669FEE1.8812.1230AD@pageexec.freemail.hu>
In-reply-to: <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
References: <20151209172101.GA70633@davidb.org>, <1449770155.8579.2.camel@gmail.com>, <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10 Dec 2015 at 10:42, Kees Cook wrote:

> http://kernsec.org/wiki/index.php/Exploit_Methods/Userspace_data_usage
> 
> On Thu, Dec 10, 2015 at 9:55 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> >> ARMv8 64-bit: ??
> >
> > The worst case scenario would be doing something like the x86_64 UDEREF.
> >
> >> x86 pre-late-Broadwell: nothing upstream (though UDEREF in PaX exists)
> >
> > It's worth noting that there's the pre-PCID implementation (slow and
> > vulnerable to races)

uhm, what races? the per-cpu PGD exists for that reason, regardless of PCID.

> > and then two choices of better implementations when
> > PCID is available. You probably know that already, but it's not obvious
> > to everyone else.
> 
> Yeah. PCID was Sandybridge and later?

IIRC, it is more like Westmere and later.
