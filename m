Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E3A57BA.2040907@arm.com>
Date: Thu, 04 Aug 2011 09:26:34 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
MIME-Version: 1.0
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org> <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com> <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org> <d844457bba74be419d2434c533fdb4e1@localhost> <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com> <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
In-Reply-To: <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/08/11 01:35, Linus Torvalds wrote:
> On Wed, Aug 3, 2011 at 12:30 AM, Marc Zyngier <marc.zyngier@arm.com> wrot=
e:
>>
>> driver_init() is called from do_basic_setup(), before any initcall...
>=20
> Ok, thanks everybody. I think the proper fix is the attached patch.
> It's crazy to have usermode helpers enabled early during boot when
> init etc haven't even been set up.
>=20
> So does this finally fix the problem (I realize that there are other
> patches floating around that *also* fix it, so please test this
> without those other patches).

This patch alone doesn't cure the problem... However, if combined with
the pure_initcall patch, it boots correctly.

I'll try to gather some traces later today.

=09M.
--=20
Jazz is not dead. It just smells funny...
