Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Apr 2016 11:52:30 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
In-Reply-To: <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
Message-ID: <alpine.DEB.2.20.10.1604061152180.13127@trent.utfs.org>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com> <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com> <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com> <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem
 file
To: ed@abdsec.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 6 Apr 2016, ed@abdsec.com wrote:
> First, I wrote your attached patch, but then I thought zeroing other
> /proc/iomem values would be better. So I changed it.

On my systems, /proc/iomem, /proc/ioports and others get their 
world-readable bits removed during bootup - I guess that would mitigate 
this issue too?

Christian.
-- 
BOFH excuse #184:

loop found in loop in redundant loopback
