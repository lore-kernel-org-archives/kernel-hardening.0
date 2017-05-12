Message-ID: <1494624236.4521.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 12 May 2017 17:23:56 -0400
In-Reply-To: <CAGXu5jJu=VTqp2tzkPB4RAVxdGC+_SSQwrUwdzWpu24AA-zEcg@mail.gmail.com>
References: 
	<CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
	 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
	 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
	 <20170512072802.5a686f23@mschwideX1>
	 <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
	 <20170512075458.09a3a1ce@mschwideX1>
	 <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
	 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
	 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
	 <20170512202106.GO22219@n2100.armlinux.org.uk>
	 <20170512210645.GS390@ZenIV.linux.org.uk>
	 <CAGXu5jJu=VTqp2tzkPB4RAVxdGC+_SSQwrUwdzWpu24AA-zEcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?ISO-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul
 E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnd Bergmann <arnd@arndb.de>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, James Morse <james.morse@arm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> overflow into adjacent allocations (fixed by VMAP_STACK).

99% fixed, but it's possible to skip over the guard page without
-fstack-check enabled (plus some edge cases need to be fixed in GCC),
unless VLAs were forbidden in addition to the existing large frame size
warning.

I'm not sure about in-tree code, but Qualcomm had some of these
improperly bounded VLA vulnerabilities in their MSM kernel...
