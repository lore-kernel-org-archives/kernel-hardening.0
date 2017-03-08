MIME-Version: 1.0
In-Reply-To: <20170308215814.GG21222@n2100.armlinux.org.uk>
References: <20170308213844.131877-1-thgarnie@google.com> <20170308215814.GG21222@n2100.armlinux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Mar 2017 14:20:24 -0800
Message-ID: <CALCETrX1RpjZxdo1aauQa8hGQPO1Dzn5gU6NoT1CvSKo8ea1uQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/4] syscalls: Restore address limit after a syscall
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Alexander Potapenko <glider@google.com>, Jan Beulich <JBeulich@suse.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Laura Abbott <labbott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 8, 2017 at 1:58 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Mar 08, 2017 at 01:38:41PM -0800, Thomas Garnier wrote:
>> This patch prevents a syscall to modify the address limit of the
>> caller. The address limit is kept by the syscall wrapper and restored
>> just after the syscall ends.
>
> I would much rather architectures were given the opportunity to code up
> checks like this efficiently (iow, inline in the exit path assembly),
> rather than having to unconditionally call an additional function on
> every syscall, with its register saving overheads.
>

Me too.  I think the two config choices should be:

(a) BUG_ON(!segment_eq(...));

(b) No generic check at all -- arch code will handle it

--Andy
