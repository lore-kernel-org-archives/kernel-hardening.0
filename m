MIME-Version: 1.0
In-Reply-To: <c10289bb-e72b-b7b5-f02b-d8cab49f372c@de.ibm.com>
References: <20170309012456.5631-1-thgarnie@google.com> <c10289bb-e72b-b7b5-f02b-d8cab49f372c@de.ibm.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 9 Mar 2017 07:53:54 -0800
Message-ID: <CAJcbSZH7xoBGsD7A4odpYrWopziWrc8sifAUiUgQmVnYkxwo4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andre Przywara <andre.przywara@arm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Thu, Mar 9, 2017 at 4:32 AM, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Can you please disable that for s390?  (e.g. by setting
> CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE for s390)
> We have a separate address space for kernel/user so the logic will
> be slightly different and is already handled in
>
> commit b5a882fcf146c87cb6b67c6df353e1c042b8773d
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Fri Feb 17 08:13:28 2017 +0100
>
>     s390: restore address space when returning to user space
>

No problem, I will add it on the next iteration of this change.

-- 
Thomas
