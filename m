Date: Wed, 21 Jun 2017 09:16:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170621081601.g6fsf6i3mxzar5sn@localhost>
References: <20170615011203.144108-1-thgarnie@google.com>
 <20170615011203.144108-3-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615011203.144108-3-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v10 3/3] arm64/syscalls: Check address limit on user-mode
 return
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 14, 2017 at 06:12:03PM -0700, Thomas Garnier wrote:
> Ensure the address limit is a user-mode segment before returning to
> user-mode. Otherwise a process can corrupt kernel-mode memory and
> elevate privileges [1].
> 
> The set_fs function sets the TIF_SETFS flag to force a slow path on
> return. In the slow path, the address limit is checked to be USER_DS if
> needed.
> 
> [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> v10 redesigns the change to use work flags on set_fs as recommended by
> Linus and agreed by others.
> 
> Based on next-20170609
> ---
>  arch/arm64/include/asm/thread_info.h | 4 +++-
>  arch/arm64/include/asm/uaccess.h     | 3 +++
>  arch/arm64/kernel/signal.c           | 5 +++++
>  3 files changed, 11 insertions(+), 1 deletion(-)

For arm64:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
