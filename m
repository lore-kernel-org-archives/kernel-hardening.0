Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
Date: Wed, 6 Apr 2016 14:19:22 -0700
Message-ID: <CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 10:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'd find a patch like the attached to be perfectly acceptable (in
> fact, we should have done this long ago).

I just committed it, let's see if some odd program uses the iomem
data. I doubt it, and I always enjoy improvements that remove more
lines of code than they add.

              Linus
