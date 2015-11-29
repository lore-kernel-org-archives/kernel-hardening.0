Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 29 Nov 2015 09:08:53 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151129080853.GB23721@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <5656F7A2.738.131F89C0@pageexec.freemail.hu>
 <20151127080554.GB24991@gmail.com>
 <565876F3.21515.18F8DF8F@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565876F3.21515.18F8DF8F@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: PaX Team <pageexec@freemail.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* PaX Team <pageexec@freemail.hu> wrote:

> i don't see the compile time vs. runtime detection as 'competing' approaches, 
> both have their own role. [...]

That's true - but only as long as 'this can be solved in tooling!' is not used as 
an excuse to oppose the runtime solution and we end up doing neither.

Thanks,

	Ingo
