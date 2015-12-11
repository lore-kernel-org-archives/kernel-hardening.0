Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <6439.1449856475@turing-police.cc.vt.edu>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
	<1449770155.8579.2.camel@gmail.com>
	<CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
	<1449774477.8579.4.camel@gmail.com>
	<CAGXu5j+OhUjRZSfCoFZeAY23-rzGDQ_6cU886BNSr3PCzQ60Hw@mail.gmail.com>
	<99FC4B6EFCEFD44486C35F4C281DC6731F1DF8B1@ORSMSX107.amr.corp.intel.com>
	<CAGXu5jLU=tbyCm2Jjjj1RshygiFEYMKNtbwPs6p-seCkJ2Ajdw@mail.gmail.com>
	<6439.1449856475@turing-police.cc.vt.edu>
Date: Fri, 11 Dec 2015 10:44:40 -0800
Message-ID: <CAGXu5jLbhCVxEce0czNRY8VSOC+BBZzqEjUNbTB8gp5EoA7+bg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "Schaufler, Casey" <casey.schaufler@intel.com>, Catalin Marinas <catalin.marinas@arm.com>, PaX Team <pageexec@freemail.hu>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ralf Baechle <ralf@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 11, 2015 at 9:54 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 10 Dec 2015 11:45:35 -0800, Kees Cook said:
>> On Thu, Dec 10, 2015 at 11:38 AM, Schaufler, Casey
>
>> That's great! Thanks for speaking up. Another area that hasn't seen
>> any traction yet is PAX_USERCOPY. Valdis seems to be MIA, so I'd love
>> to see someone else take on that chunk of work.
>
> Whoops. sorry.. I just didn't have anything in a state ready to share,
> and I got sidetracked by a week in the hospital (am all OK now, thankfully).

Yikes! Glad you're okay. If other people have more time to dedicate to
PAX_USERCOPY extraction, maybe you could help with testing? Or what do
you think?

> Biggest problem is just taking one big 7M patch and teasing out just the
> USERCOPY parts, and then re-arranging it into something that upstream will
> be willing to take.  Just lots and lots of grunt work.

Yup, that's the first step in the work. Well, first is extraction,
then figuring out the best way to upstream.

> I don't suppose the grsecurity guys have a git repo where a lot of the
> heavy duty lifting is already done? :)

AIUI, no such thing exists. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
