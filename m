Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <21496.1468263917@turing-police.cc.vt.edu>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com> <21496.1468263917@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 11 Jul 2016 15:14:21 -0400
Message-ID: <CAGXu5jKLd40NsY+eqo6R=RMv61xjUhTyRo6-oUf2nxuL_AZ-sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Shubham Bansal <illusionist.neo@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 11, 2016 at 3:05 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 10 Jul 2016 21:34:29 +0530, Shubham Bansal said:
>
>> Hi Kees,
>>
>> Sorry for the late reply. I am having some problems with arranging a lot of
>> mails from the list.
>
> If you're not sure where to start, try picking up all the patches we've got
> so far, applying them to a reasonably recent kernel, and seeing what breaks.
>
> As far as I know, I'm the only crash test dummy at the moment, so having
> somebody else testing with a kernel config different than what I have
> on my laptop would be valuable.  So far I've identified that ptrace()
> and some (but not all) variants of setsockopt() have issues with Kees's
> usercopy patches.
>
> Kees:  Am I the only guy who's trying this on a SLAB rather than SLUB box?

I think you're doing the bulk of the SLAB testing (though I'd
encourage you to drop the whitelist testing for now, since I want to
make sure the rest of the series is solid first). I've done limited
testing (mostly with boot and lkdtm) on SLAB, SLUB, and SLOB (and the
earlier SLOB series failed so badly for me that I dropped SLOB support
entirely).

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
