Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Apr 2016 21:19:29 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20160406191929.GA12088@pd.tnic>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
 <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
 <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
 <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
 <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
 <1459968792.2818.22.camel@debian.org>
 <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
 <1459969867.2818.28.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1459969867.2818.28.camel@debian.org>
Subject: Re: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on
 leakage in /proc/iomem file
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 06, 2016 at 09:11:07PM +0200, Yves-Alexis Perez wrote:
> On mer., 2016-04-06 at 12:02 -0700, Linus Torvalds wrote:
> > So yeah, maybe swap partitions are still more common than I thought.
> > And I didn't even consider the possibility that people would hibernate
> > a desktop like you do.
> 
> To be fair, it's *my* use case, because suspend won't work but I'm lazy and
> don't like to reopen everything I was doing, but still have to shut the
> machine down once in a while (or to save power).

I'm doing exactly the same thing with my workstation:

echo 3 > /proc/sys/vm/drop_caches
echo "shutdown" > /sys/power/disk
echo "disk" > /sys/power/state

*exactly* because I don't want to restart everything. :-)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
