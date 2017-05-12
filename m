MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170512214144.GT390@ZenIV.linux.org.uk>
References: <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1> <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1> <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
 <20170512202106.GO22219@n2100.armlinux.org.uk> <20170512210645.GS390@ZenIV.linux.org.uk>
 <CAGXu5jJu=VTqp2tzkPB4RAVxdGC+_SSQwrUwdzWpu24AA-zEcg@mail.gmail.com> <20170512214144.GT390@ZenIV.linux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 12 May 2017 14:50:19 -0700
Message-ID: <CAGXu5jJ=mbbKJWR7Vrce9cNm2sjRUUzB0SvhZRC8NE+7rfCg3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnd Bergmann <arnd@arndb.de>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Daniel Micay <danielmicay@gmail.com>, James Morse <james.morse@arm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 12, 2017 at 2:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, May 12, 2017 at 02:17:19PM -0700, Kees Cook wrote:
>
>> Two things are at risk from stack exhaustion: thread_info (mainly
>> addr_limit) when on the stack (fixed by THREAD_INFO_IN_TASK), and
>
> Really?  Let's take a look at arm, for example:
>
> struct thread_info {
>         unsigned long           flags;          /* low level flags */
>         int                     preempt_count;  /* 0 => preemptable, <0 => bug */
>         mm_segment_t            addr_limit;     /* address limit */
>         struct task_struct      *task;          /* main task structure */
>
> and current() is defined as current_thread_info()->task.
>
> Seriously, look at these beasts.  Overwriting ->addr_limit is nowhere near
> the top threat.  If attacker can overwrite thread_info, you have lost.

I don't disagree, but the type of attack is different. If the attacker
overwrites task_struct pointer, then they need to have built an false
one, and that may be made difficult by PAN, or need to know more about
kernel memory layout (rather than only stack depth), etc. Attacking
addr_limit makes it very very easy to upgrade attack capabilities. I'm
not say thread_info shouldn't be moved off the stack.

-Kees

-- 
Kees Cook
Pixel Security
