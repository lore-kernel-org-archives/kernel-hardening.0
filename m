Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 25 Nov 2015 12:14:29 +0100
MIME-Version: 1.0
Message-ID: <56559815.30416.DC24D0B@pageexec.freemail.hu>
In-reply-to: <56558826.1060202@ladisch.de>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>, <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>, <56558826.1060202@ladisch.de>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Mathias Krause <minipli@googlemail.com>, kernel-hardening@lists.openwall.com, Clemens Ladisch <clemens@ladisch.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Nov 2015 at 11:06, Clemens Ladisch wrote:

> Mathias Krause wrote:
> > [...]
> > So, prior extending the usage of the __read_only annotation some
> > toolchain support is needed. Maybe a gcc plugin that'll warn/error on
> > code that writes to such a variable but is not __init itself.
> 
> Or mark them as "const".  This would require the initialization code to
> cast it away, probably with a helper macro.

no, that'd be undefined behaviour and in practice gcc would take advantage
of it and produce unintended (and quite broken) code. if the constified object
is modified from a different translation unit then the compiler is free
to assume that it can constant propagate its initialization value into uses,
completely breaking the code that (forcibly) writes to it.

however as a poor man's detector for such __read_only violations it's
possible to just make the object const temporarily (without casting away
the write attempts!), recompile the tree and see if any writes outside
__init functions pop up.
