MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170323172515.27950-1-thgarnie@google.com>
References: <20170323172515.27950-1-thgarnie@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Mar 2017 13:15:08 -0700
Message-ID: <CAGXu5jKbqOvb2TtfpXhjPQFxEShaBu=RbBQORtqhcF1bD3As6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/4] syscalls: Restore address limit after a syscall
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 23, 2017 at 10:25 AM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch ensures a syscall does not return to user-mode with a kernel
> address limit. If that happened, a process can corrupt kernel-mode
> memory and elevate privileges.
>
> For example, it would mitigation this bug:
>
> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>
> The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
> added so each architecture can optimize this change.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Awesome. :) I've tested this on x86 and arm with the LKDTM patch I'll
post in a moment.

[   46.977823] lkdtm: Performing direct entry CORRUPT_USER_DS
[   46.978966] lkdtm: setting bad task size limit
[   46.980302] ------------[ cut here ]------------
[   46.981219] kernel BUG at ./include/linux/syscalls.h:200!

Tested-by: Kees Cook <keescook@chromium.org>

(Also note, your Signed-off-by lines are missing in patches 2-4)

-- 
Kees Cook
Pixel Security
