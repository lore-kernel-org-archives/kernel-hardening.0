Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 14:53:37 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161027135337.GB30535@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <20161027103143.GB27135@leverpostej>
 <CAEXv5_iLo5ezNBFiMbQ91Nj_dh41uWZiMtxCynAsCZhO+2wHpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_iLo5ezNBFiMbQ91Nj_dh41uWZiMtxCynAsCZhO+2wHpw@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC 0/2] arm: implementation of
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Thu, Oct 27, 2016 at 08:45:33AM -0400, David Windsor wrote:
> On Thu, Oct 27, 2016 at 6:32 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Unfortunately, I'm only somewhat familiar with the ARM atomics, and I
> > have absolutely no familiarity with the existing PaX patchset.
> >
> > For both of these, some background rationale would be helpful. e.g. what
> > does the fixup entry do? When is it invoked?
> 
> For your reference, documentation on the original PaX protection
> (known there a PAX_REFCOUNT) can be found here:
> https://forums.grsecurity.net/viewtopic.php?f=7&t=4173

Thanks; that's very helpful. For subsequent postings it would be worth
referring to this in the cover letter, along with a rough summary.

> With respect to documentation, there is a patch in this series that
> adds Documentation/security/hardened-atomic.txt, which references the
> above-mentioned forum post.

Unfortunately, that's not part of *this* series, and the prerequisite
series with this was not linked to. I can find that by going through the
list, but for the sake of others, having an explicit link to the
relevant version of the other series would be more helpful.

Thanks,
Mark.
