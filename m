Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 18 Feb 2016 11:46:42 +0100
MIME-Version: 1.0
Message-ID: <56C5A112.25195.35DDEA@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJmpq_2mmTLD0VbnY1SBF5b5Rr04HKWfD1LEaGxnztFdQ@mail.gmail.com>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>, <20160217234306.GA59532@davidb.org>, <CAGXu5jJmpq_2mmTLD0VbnY1SBF5b5Rr04HKWfD1LEaGxnztFdQ@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] ARM: vdso: Mark vDSO code as read-only
To: David Brown <david.brown@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Feb 2016 at 15:48, Kees Cook wrote:

> On Wed, Feb 17, 2016 at 3:43 PM, David Brown <david.brown@linaro.org> wrote:

> > Is there a possible future consideration to perhaps make .rodata read
> > only much earlier?
> 
> Yeah, this will likely be a future improvement. Some architectures
> already mark .rodata before the mark_rodata_ro() call. Once we start
> to have more use of postinit-readonly, I suspect we'll see more
> clarification of when those things happen.

FYI, PaX had enforced early rodata on i386 during the 2.4 series (i.e.,
decade+ ago) but i abandoned it for 2.6 due to the maintenance burden
coupled with its low benefit...
