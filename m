MIME-Version: 1.0
In-Reply-To: <20171230175804.7354-1-alonid@gmail.com>
References: <20171230175804.7354-1-alonid@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Sat, 30 Dec 2017 22:42:49 +0100
Message-ID: <CAG48ez2gYFqifarkx3g8QP0aSzGswLpjxq_xPf4WiCPBn-GWAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 0/5] RFC: Public key encryption of
 dmesg by the kernel
To: Dan Aloni <dan@kernelim.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 30, 2017 at 6:57 PM, Dan Aloni <dan@kernelim.com> wrote:
> From: Dan Aloni <dan@kernelim.com>
>
> Hi All,
>
> There has been a lot of progress in recent times regarding the removal
> of sensitive information from dmesg (pointers, etc.), so I figured - why
> not encrypt it all? However, I have not found any existing discussions
> or references regarding this technical direction.
>
> I am not sure that desktop and power users would like to have their
> kernel message encrypted, but there are scenarios such as in mobile
> devices, where only the developers, makers of devices, may actually
> benefit from access to kernel prints messages, and the users may be
> more protected from exploits.

What is the benefit of your approach compared to setting
dmesg_restrict=1 or something like that and letting userland decide
who should get access to raw dmesg output and in what form?
