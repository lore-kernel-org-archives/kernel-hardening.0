Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFzG+s9KvSOJHvsUczG_d66f+QbBWiWfqLC21mHswnfm-A@mail.gmail.com>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org>
 <d844457bba74be419d2434c533fdb4e1@localhost> <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
 <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
 <20110803175016.fb80b7f3.akpm@linux-foundation.org> <CA+55aFzG+s9KvSOJHvsUczG_d66f+QbBWiWfqLC21mHswnfm-A@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 4 Aug 2011 03:15:51 +0200
Message-ID: <CAPXgP1258BjQ8vsdpicq0oxS0Onva9DYu5se6dmQKsT+-He-UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <marc.zyngier@arm.com>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Greg KH <greg@kroah.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 4, 2011 at 03:01, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Aug 3, 2011 at 2:50 PM, Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>>
>> Well, it's still a workaround. =C2=A0We'll still have driver_init() tryi=
ng
>> to run userspace helpers at an inappropriate time, and failing to do
>> so. =C2=A0Either something will break or it should not be attempting
>> attempting to do this at all.
>
> Well, it has never worked before either, so I wouldn't call it a
> "workaround", more of a "insane subsystems do user-mode helpers for
> crazy small things, and at crazy times. Stop them from wasting our
> time and effort at those crazy times when we know they would fail
> anyway".
>
>> Perhaps Kay and Greg can suggest how we can fix all this up?
>
> I think just not calling user-mode when user-mode isn't ready is a real f=
ix.

Yes, we should default to off, and probably only enable it just right
before we start /sbin/init from the mounted root or in initramfs.
There should be no useful use of /sbin/hotplug before we mounted root,
or unpacked initramfs.

> The fact that the device models send an absolutely *insane* amount of
> events for everything, and don't track "this is the bootup device
> scan" on their own is kind of sad, but it's how they roll. This fixes
> it at a core level, so that the device layer doesn't have to track the
> "am I booting, or is this a dynamic event?" at all.

It is insane, and the entire uevent hookup with /sbin/hotplug should
just be removed. We send from 1000 to many 1000s of events at bootup,
and forking a binary here makes not much sense these days.

All distros default to CONFIG_UEVENT_HELPER_PATH=3D"" because nothing
else really works anymore, some boxes don't even boot up.
/sbin/hotplug worked fine when we all had one USB mouse connected and
needed to load like 5 drivers for the system, but not today.

It's a broken concept today, at least in the way we plug it into the
driver core makes no sense today, it is just a heritage from the old
days.

Kay
