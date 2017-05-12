MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com> <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com> <20170509111007.GA14702@kroah.com>
 <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1> <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1> <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 May 2017 12:08:57 -0700
Message-ID: <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Kees Cook <keescook@chromium.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Greg KH <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 12, 2017 at 12:01 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Yeah, the risk for "corrupted addr_limit" is mainly a concern for
> archs with addr_limit on the kernel stack. If I'm reading things
> correctly, that means, from the archs I've been paying closer
> attention to, it's an issue for arm, mips, and powerpc:

I don't understand why people are looking at addr_limit as some kind
of special thing.

If somebody is smashing the stack and corrupting thread info data, the
game is over. addr_limit is the *least* of your problems, and it's not
even all that likely that it will be increasing (it's much more likely
that it would be overwritten with a smaller value).

Quite frankly, this kind of idiotic discussion just makes me question
the whole idea of the patch.

Any "security" that is this specific is not real security, it's just
masturbatory garbage.

It may be worth checking that people use "set_fs()" properly. But stop
this idiotic crap. It just makes the kernel security people look like
the crazies.

There are enough incompetent crazy security people, don't go there.
The kinds of things it is worth protecting against are the big class
of generic issues, not the kind of "oh, but imagine if a cosmic ray
flips this particular word in memory" kind of crap that ignores all
the other words of memory.

Seriously, Kees. You are just making security people look bad. Stop it.

                       Linus
