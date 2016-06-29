Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87vb0tgh1n.fsf@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
 <20160628133520.5baf644afca97c464b9cdb17@gmail.com> <87vb0tgh1n.fsf@rasmusvillemoes.dk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Jun 2016 07:50:25 -0700
Message-ID: <CAGXu5jLMsdeQ6XwBm-+kT0OkQtm78SQJRPFWueZ=wSUPeadwsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/2] Add the initify gcc plugin
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2016 at 2:05 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On Tue, Jun 28 2016, Emese Revfy <re.emese@gmail.com> wrote:
>
>> The kernel already has a mechanism to free up code and data memory that
>> is only used during kernel or module initialization.
>> This plugin will teach the compiler to find more such code and data that
>> can be freed after initialization.
>> It has two passes. The first one tries to find all functions that
>> can be become __init/__exit. The second one moves string constants
>> (local variables and function string arguments marked by
>> the nocapture attribute) only referenced in __init/__exit functions
>> to the __initconst/__exitconst sections.
>> It reduces memory usage. This plugin can be useful for embedded systems.
>
> May I suggest, as a followup patch, a debug option/plugin parameter to
> put the strings in a section which will not be reaped after init, but
> just marked inaccessible, with graceful handling of bad accesses (print
> a big fat warning, make the page(s) readable, continue)?

Is there a clean way to do this that isn't arch-specific?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
