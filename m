Date: Mon, 12 Mar 2018 06:58:04 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <1166411830.411906.1520834284931@email.1und1.de>
In-Reply-To: <20180312054613.GG8631@eros>
References: <1520818673-14084-1-git-send-email-me@tobin.cc>
 <20180312054613.GG8631@eros>
Subject: Re: [PATCH v2] staging: vchiq_arm: Clear VLA warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Eric Anholt <eric@anholt.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Tobin C. Harding" <me@tobin.cc>
Cc: Tycho Andersen <tycho@tycho.ws>, driverdev-devel@linuxdriverproject.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

> "Tobin C. Harding" <me@tobin.cc> hat am 12. M=C3=A4rz 2018 um 06:46 gesch=
rieben:
>=20
>=20
> On Mon, Mar 12, 2018 at 12:37:53PM +1100, Tobin C. Harding wrote:
> > The kernel would like to have all stack VLA usage removed[1].  The arra=
y
> > here is fixed (declared with a const variable) but it appears like a VL=
A
> > to the compiler.  Also, currently we are putting 768 bytes on the
> > stack.  This function is only called on the error path so performance i=
s
> > not critical, let's just allocate the memory instead of using the
> > stack.  This saves stack space and removes the VLA build warning.
> >=20
> > kmalloc a buffer for dumping state instead of using the stack.
> >=20
> > [1]: https://lkml.org/lkml/2018/3/7/621
> >=20
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > ---
>=20
> Drop this please, leaks memory.

except from the leak, did you test this patch on a RPi?

Thanks
Stefan

>=20
> thanks,
> Tobin.
