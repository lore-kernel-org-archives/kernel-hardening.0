Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
From: Ho-Eun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170220082029.fiosdnwx7rauawgr@linutronix.de>
Date: Tue, 21 Feb 2017 14:47:08 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9E073BF-14BD-485F-9FB6-BE17A385C08A@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-5-git-send-email-hoeun.ryu@gmail.com>
 <20170220082029.fiosdnwx7rauawgr@linutronix.de>
Subject: [kernel-hardening] Re: [RFC 5/7] cpu: mark ro_mostly_after_init for cpuhp_ap/bp_states
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On 20 Feb 2017, at 5:20 PM, Sebastian Andrzej Siewior =
<bigeasy@linutronix.de> wrote:
>=20
> On 2017-02-19 19:04:08 [+0900], Hoeun Ryu wrote:
>> It would be good that `__ro_mostly_after_init` is marked to cpuhp =
state
>> objects.=20
> why?
>=20

I=E2=80=99m requesting for comments of a new feature called =
__ro_mostly_after_init section marker.
It=E2=80=99s similar to __ro_after_init, but the section can be writable =
for some point of time.
Please see the cover letter [1] and the first patch [2].

[1] : https://lkml.org/lkml/2017/2/19/29
[2] : https://lkml.org/lkml/2017/2/19/32

> Sebastian
