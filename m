Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 6 Apr 2016 22:49:55 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160406204955.GA23336@gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
 <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
 <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
 <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
 <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
 <1459968792.2818.22.camel@debian.org>
 <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on
 leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yves-Alexis Perez <corsac@debian.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@denx.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So yeah, maybe swap partitions are still more common than I thought. And I 
> didn't even consider the possibility that people would hibernate a desktop like 
> you do.

Also many distros will hibernate automatically on critically low battery (when 
suspend won't save the system).

It would be much better to fix the kASLR/hibernation incompatibility ...

Just a random guess: much of the hibernation incompatibility comes from the fact 
that on hibernation bootups the kASLR seed changes, which breaks hibernated kernel 
addresses, right?

That should be easy to fix: if we added a kaslr_seed=xyz boot option, and added 
that parmeter automatically (without showing it in /proc/cmdline ;-) on 
hibernation bootups, we could solve much of the incompatibility, right?

This means that the first 'cold' bootup would set the kASLR seed - and subsequent 
hibernated bootups would inherit it. That should be perfectly OK as long as we 
don't expose the seed somewhere.

We could also write the kASLR seed to the hibernation image, but I don't think we 
have the value available early enough - a boot option is better.

Thanks,

	Ingo
