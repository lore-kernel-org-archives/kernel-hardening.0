Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+TAncQVkW6ArfL6CfT_LCHVE-HUtW+0kq3+FK+1rK_Qg@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	<CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	<CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	<CA+55aFxSCFCoWcMapn10GyXvKpy5aMjGG+pa1P4Hu7sHqSTDKQ@mail.gmail.com>
	<CAGXu5j+TAncQVkW6ArfL6CfT_LCHVE-HUtW+0kq3+FK+1rK_Qg@mail.gmail.com>
Date: Wed, 6 Apr 2016 14:32:30 -0700
Message-ID: <CA+55aFxNyH_i0=02S-ZLw2wLFEAY8Dkb0zm1HT9avp+KYNtVeg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Kees Cook <keescook@chromium.org>
Cc: Emrah Demir <ed@abdsec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 2:27 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Hrm, okay. I still think just changing the perms would be less
> troublesome.

No, that would be much *more* trouble-some, because we have things
like bug-reporting documentation that tells people to send /proc/iomem
etc information on crashes. There may well be scripts like that out
there.

So it's much more likely that just removing the "Kernel code" etc
lines is not going to break anything.

            Linus
