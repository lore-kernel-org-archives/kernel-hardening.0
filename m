References: <20170311000501.46607-1-thgarnie@google.com>
 <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com>
 <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com>
 <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
 <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com>
 <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com>
 <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <8fa1a789-231f-dc2c-4a43-6406194259f9@zytor.com>
Date: Tue, 14 Mar 2017 10:53:36 -0700
MIME-Version: 1.0
In-Reply-To: <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
To: Thomas Garnier <thgarnie@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "David A . Long" <dave.long@linaro.org>, Pratyush Anand <panand@redhat.com>, Laura Abbott <labbott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/14/17 09:51, Thomas Garnier wrote:
>>
>> I wanted to comment on that thing: why on earth isn't
>> verify_pre_usermode_state() an inline?  Making it an out-of-line
>> function adds pointless extra overhead to the C code when we are talking
>> about a few instructions.
> 
> Because outside of arch specific implementation it is called by each
> syscall handler. it will increase the code size a lot.
> 

Don't assume that.  On a lot of architectures a function call can be
more expensive than a simple compare and branch, because the compiler
has to assume a whole bunch of registers are lost at that point.

Either way, don't penalize the common architectures for it.  Not okay.

	-hpa
