Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Nov 2015 15:31:22 -0800
Message-Id: <1448494286-16029-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 0/4] introduce post-init read-only memory
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

One of the easiest ways to protect the kernel from attack is to reduce
the internal attack surface exposed when a "write" flaw is available. By
making as much of the kernel read-only as possible, we reduce the
attack surface.

Many things are written to only during __init, and never changed
again. These cannot be made "const" since the compiler will do the wrong
thing (we do actually need to write to them). Instead, move these items
into a memory region that will be made read-only during mark_rodata_ro()
which happens after all kernel __init code has finished.

This introduces __ro_after_init as a way to mark such memory, and uses
it on the x86 vDSO to kill an extant kernel exploitation method. Also
adds a new kernel parameter to help debug future use and adds an lkdtm
test to check the results.

-Kees
