Date: Tue, 4 Apr 2017 20:54:46 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20170404185446.7s5zwqn2bmw2cxid@pd.tnic>
References: <20170404174727.35478-1-thgarnie@google.com>
 <20170404174727.35478-2-thgarnie@google.com>
 <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
Subject: [kernel-hardening] Re: [PATCH v6 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?utf-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 04, 2017 at 11:27:07AM -0700, H. Peter Anvin wrote:
> Finally, I can't really believe I'm the only person for whom "Specific
> usage of verity_pre_usermode_state" is completely opaque.

No, you're not. I'm missing the usual layout of the commit message
"Problem is A, we need to do B, because of C." And this particular one
needs to be pretty verbose as it is tricky lowlevel, userspace return
blabla code and I'd prefer not to have to rhyme up together myself
what's going on and what we're fixing here.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
