Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110803175016.fb80b7f3.akpm@linux-foundation.org>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org>
 <d844457bba74be419d2434c533fdb4e1@localhost> <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
 <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
 <20110803175016.fb80b7f3.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Aug 2011 15:01:05 -1000
Message-ID: <CA+55aFzG+s9KvSOJHvsUczG_d66f+QbBWiWfqLC21mHswnfm-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 3, 2011 at 2:50 PM, Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> Well, it's still a workaround. =A0We'll still have driver_init() trying
> to run userspace helpers at an inappropriate time, and failing to do
> so. =A0Either something will break or it should not be attempting
> attempting to do this at all.

Well, it has never worked before either, so I wouldn't call it a
"workaround", more of a "insane subsystems do user-mode helpers for
crazy small things, and at crazy times. Stop them from wasting our
time and effort at those crazy times when we know they would fail
anyway".

> Perhaps Kay and Greg can suggest how we can fix all this up?

I think just not calling user-mode when user-mode isn't ready is a real fix=
.

The fact that the device models send an absolutely *insane* amount of
events for everything, and don't track "this is the bootup device
scan" on their own is kind of sad, but it's how they roll. This fixes
it at a core level, so that the device layer doesn't have to track the
"am I booting, or is this a dynamic event?" at all.

               Linus
