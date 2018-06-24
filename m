Date: Sun, 24 Jun 2018 06:38:55 -0400
From: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v13 0/6] Introduce the STACKLEAK feature and a test for it
Message-ID: <rlJicRc5iVlRxMPSYI3Y9Ow3cZimuIY4gAVTbm4wtlt2JVFIX9VR3rKdNIWS0-uYYi40epQlb-lwLC4Hc9HjmIB8PLGcX3s8CNcPl9BhGzo=@protonmail.ch>
In-Reply-To: <20180624071817.GA32154@gmail.com>
References: <1527365430-8303-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJ9F-eZW5qVGebsv=wUh0kSm+edAecpztgvMC3fGeYXXA@mail.gmail.com>
 <CAGXu5jLU4En5Cf6KGf0Adpky-TF7aa=d9MTDqDKwxQuxZSLNEg@mail.gmail.com>
 <20180622013339.GA10129@gmail.com>
 <CAGXu5jJgmvqWzJ1kbq-zTsmwkcc9FPXgBdT9qf+Hc4tLcLh87w@mail.gmail.com>
 <CAGXu5j+bUEPZp1LAc82RDmvCXc=YnsOVP3FdzCX_4WsZTXcCBA@mail.gmail.com>
 <20180622031645.GA26826@gmail.com>
 <feb24168-9528-dfd0-be05-daea3e0b19b9@linux.com>
 <20180624071817.GA32154@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@tycho.ws>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On June 24, 2018 9:18 AM, Ingo Molnar <mingo@kernel.org> wrote:

> -   Alexander Popov alex.popov@linux.com wrote:
>=20
> > On 22.06.2018 06:16, Ingo Molnar wrote:
> >=20
> > > -   Kees Cook keescook@chromium.org wrote:
> > >=20
> > > > On Thu, Jun 21, 2018 at 7:07 PM, Kees Cook keescook@chromium.org wr=
ote:
> > > >=20
> > > > > It needs rebasing to -rc1 (which I've done already, but I'm still
> > > > >=20
> > > > > doing build tests on it).
> > > >=20
> > > > It's passed basic allmodconfig builds:
> > > >=20
> > > > tree: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.gi=
t
> > > >=20
> > > > branch: for-next/stackleak
> > >=20
> > > Ok, that's 6 patches - please send the latest for review as emails to=
 lkml the
> > >=20
> > > usual. Thanks!
> >=20
> > I'll resend the rebased v13 shortly.
>=20
> Well, I assume there were v12->v13 changes, correct?
>=20
> If yes, and if it's on a different base krnel, then why did you call it a
>=20
> 'resend'? That will only get fewer people to review it ... Please don't d=
o that
>=20
> for future iterations.
>=20
> Thanks,
>=20
> Ingo

v13 was sent for the first time a month ago and you were on the list of rec=
ipients:
http://www.openwall.com/lists/kernel-hardening/2018/05/26/6

Jordan
