Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20110622190739.GB14351@albatros>
References: <20110622095341.GA3353@albatros>
	<1308760683.10423.16.camel@Joe-Laptop>
	<20110622191022.66135615@lxorguk.ukuu.org.uk>
	<20110622190739.GB14351@albatros>
Date: Thu, 23 Jun 2011 20:11:46 +0200
Message-ID: <BANLkTimQxzqstxLnO-_dDMoRbWbGPQJrvA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] kernel: escape non-ASCII and control characters in printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 21:07, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Wed, Jun 22, 2011 at 19:10 +0100, Alan Cox wrote:
>> If that is set you shouldn't be filtering out unicode, just control code=
s.
>
> OK.
>
>> Minor other nit is that you might want to allow BEL through and you
>> certainly want to allow tab through.
>
> In what situation do you think BEL makes sense in kernel log? =C2=A0I can=
not
> image the situation. =C2=A0Alarms should use KERN_EMERG/KERN_ALERT log le=
vel.

Does BEL work? Last time I tried fancy things (e.g. color output
depending on the
message level), it didn't work. I only got strange characters.

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
