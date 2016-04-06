Reply-To: kernel-hardening@lists.openwall.com
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	<CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
	<CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
	<CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
Date: Wed, 06 Apr 2016 21:23:00 +0200
In-Reply-To: <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 6 Apr 2016 11:43:11 -0700")
Message-ID: <87inzuv8x7.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I suspect there really aren't all that many hibernation users out
> there at all, and that yes, that would be the right default.
>
> Hibernation is really quite nasty when you have to have a fairly big
> special partition for it, and shrink your memory down. Writing things
> to disk was a whole lot more reasonable back in the days when laptops
> had 16MB of memory.
>
> I really wonder how many people use it with a modern laptop and
> distro. I doubt it's much faster than just rebooting the whole system
> anyway, and there are lots of downsides.

Huh? Do modern laptops now have infinite battery capacity?  I regularily
use hibernation as emergency shutdown when the battery runs out.  You
mean that never happens to other people?  Or you just take the hit and
stops everything you were currently doing, saving every open file etc?


Bj=C3=B8rn
