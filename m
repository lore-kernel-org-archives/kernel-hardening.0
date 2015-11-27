Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFxH+Gy4U8WbGWXh+ybrvng8tw1=2CrjPnJSju3+c5XpbA@mail.gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
	<CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
	<565595F5.32536.DB9FE75@pageexec.freemail.hu>
	<20151126085425.GA29848@gmail.com>
	<CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
	<20151127075959.GA24991@gmail.com>
	<CA+55aFxH+Gy4U8WbGWXh+ybrvng8tw1=2CrjPnJSju3+c5XpbA@mail.gmail.com>
Date: Fri, 27 Nov 2015 10:03:01 -0800
Message-ID: <CA+55aFziK-bv2eyK4PULJfV3qZeCLeKjBjUtrN96Kc-UpXrB9A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 27, 2015 at 10:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - just oops and kill the machine, like for any other unhandled kernel
> page fault. This is probably what you should have on a server

Just to clarify: the "just oops" obviously doesn't have to kill the
machine, it depends on what your oops policy is, with the default
obviously being the normal "kill that particular thread" if at all
possible.

Machine-killing is appropriate in some secure situations, but most of
the time it just makes it too damn hard to debug since the error often
doesn't get logged. In some situations we obviously can't avoid it,
but..

               Linus
