Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1459968792.2818.22.camel@debian.org>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	<CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
	<CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
	<CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
	<1459968792.2818.22.camel@debian.org>
Date: Wed, 6 Apr 2016 12:02:25 -0700
Message-ID: <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on
 leakage in /proc/iomem file
To: Yves-Alexis Perez <corsac@debian.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:53 AM, Yves-Alexis Perez <corsac@debian.org> wrote:
>
> Actually you just have to have a swap partition, which people still set as
> more or less the ram size, I think, so all in all it works (especially if
> people hibernate without the ram completely used).

I guess people still do those. I have one on my laptop, but that's
because I only have 4GB of RAM in that thing. I'd never hibernate it,
though. If I can't just get it back from suspend immediately, I'd
rather just boot it from scratch.

On bigger machines where I have 16GB or more, I tend to go "I'd rather
fail early and perhaps buy more RAM than see the slowdown or write to
my precious ssd". I guess I might have a swap partition just because a
distro did one for me and I didn't catch it.

So yeah, maybe swap partitions are still more common than I thought.
And I didn't even consider the possibility that people would hibernate
a desktop like you do.

             Linus
