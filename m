Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 16 Nov 2016 15:16:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161116151611.GD11228@leverpostej>
References: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 16, 2016 at 10:39:38PM +0800, Gengjia Chen wrote:
>    Hello kees and everyone :

Hi,

>    This email introduces two patches.

As a general note, it would be better to use git send-email to send
these patches as separate emails, in reply to a cover letter. That's
more in keeping with usual Linux list style, and makes review and
application of patches easier/possible.

e.g. assuming you have two patches on a branch foo:

$ git format-patch --cover-leter foo~2..foo
$ ${EDITOR} 0000-* # write your cover letter comments
$ git send-email --to=${whoever} --cc={who_else} *.patch

See $(man git-send-email) and $(man git-config) for how to set that up.

>    Patch 1 introduce the write-rarely memory section for
>    those kernel objects which are read only mostly 
>    but need to be written to sometimes.
>    Patch 2 introduce two helper functions (mark_wrdata_rw/
>    mark_wrdata_ro) to make __write_rarely memory section
>    writable or unwritable. They play like the pax_open_kernel/
>    pax_close_kernel functions in grsecurity patch.Right now 
>    this only been implemented on arm32.

I've mentioned this elsewhere, but I don't think {open,close}_kernel()
works as an interface. Specifically, I don't believe it can be safely
and efficiently implemented for arm with LPAE, nor arm64.

To cater for those it may be possible to use a temporary RW mapping
separate from the usual kernel mapping (e.g. in TTBR0 on arm64). It
should be possible to have an API that can use either approach, if
writers are suitable annotated.

That all said, from the two patches it's not even clear how this would
be used, as nothing is marked __write_rarely, nor are any writers
updated. A demonstration would be helpful.

It would also be worth getting these onto the relevant lists (per
scripts/get_maintainer.pl), so as to get the relevant core and
architecture maintainers involved as early as possible.

Thanks,
Mark.
