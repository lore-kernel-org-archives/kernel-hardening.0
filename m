Date: Wed, 3 Jan 2018 22:41:42 +0200
From: Dan Aloni <dan@kernelim.com>
Message-ID: <20180103204142.GB28211@gmail.com>
References: <20171230175804.7354-1-alonid@gmail.com>
 <CAG48ez2gYFqifarkx3g8QP0aSzGswLpjxq_xPf4WiCPBn-GWAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2gYFqifarkx3g8QP0aSzGswLpjxq_xPf4WiCPBn-GWAw@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/5] RFC: Public key encryption of
 dmesg by the kernel
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 30, 2017 at 10:42:49PM +0100, Jann Horn wrote:
> On Sat, Dec 30, 2017 at 6:57 PM, Dan Aloni <dan@kernelim.com> wrote:
> > From: Dan Aloni <dan@kernelim.com>
> >
> > Hi All,
> >
> > There has been a lot of progress in recent times regarding the removal
> > of sensitive information from dmesg (pointers, etc.), so I figured - why
> > not encrypt it all? However, I have not found any existing discussions
> > or references regarding this technical direction.
> >
> > I am not sure that desktop and power users would like to have their
> > kernel message encrypted, but there are scenarios such as in mobile
> > devices, where only the developers, makers of devices, may actually
> > benefit from access to kernel prints messages, and the users may be
> > more protected from exploits.
> 
> What is the benefit of your approach compared to setting
> dmesg_restrict=1 or something like that and letting userland decide
> who should get access to raw dmesg output and in what form?

Inter-process vulnerabilities (via sockets, shared memory, etc.) can
still allow one process with lesser dmesg privileges to exploit another
with higher privileges. Once the higher process is exploited, without
this approach, a plaintext dmesg is exposed for kernel exploitation
through it.

There can be systems designed in such a way that the most privileged
userland process would still be barred from accessing the raw hardware
directly, and in those systems we still want to guard the kernel from
exploits, in order to keep the hardware protected, but still allow
developers to debug the kernel.

-- 
Dan Aloni
