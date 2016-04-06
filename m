Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	<CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
	<CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
Date: Wed, 6 Apr 2016 11:43:11 -0700
Message-ID: <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Kees Cook <keescook@chromium.org>
Cc: Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 11:37 AM, Kees Cook <keescook@chromium.org> wrote:
>
> At some point I'd like to see if distros would be interested in
> inverting the default logic (maybe with a CONFIG to avoid changing the
> current behavior) where instead of needing to put "kaslr" on the
> command line to prefer kaslr over hibernation, end users would need to
> add "nokaslr" to perfer hibernation for that boot. (Bike shed config
> name: CONFIG_RANDOMIZE_BASE_ENABLED.)

I suspect there really aren't all that many hibernation users out
there at all, and that yes, that would be the right default.

Hibernation is really quite nasty when you have to have a fairly big
special partition for it, and shrink your memory down. Writing things
to disk was a whole lot more reasonable back in the days when laptops
had 16MB of memory.

I really wonder how many people use it with a modern laptop and
distro. I doubt it's much faster than just rebooting the whole system
anyway, and there are lots of downsides.

Maybe we could even just do the default switch in the kernel
independently of any distro people, and see if anybody even _notices_.

               Linus
