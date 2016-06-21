Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1466532133.2756.50.camel@redhat.com>
References: <cover.1466466093.git.luto@kernel.org> <13212319.WrhLzgRA6Z@wuerfel>
 <CAGXu5jJaWxcOKLtXG3r1XWE8NpL=GFSZwmV_UYjjv6q0135ETQ@mail.gmail.com> <1466532133.2756.50.camel@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Jun 2016 11:05:41 -0700
Message-ID: <CALCETrX-rKLa7Skr5NOannx4no1Vma2j-ahAquQNmwLYaVgwQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks
 with guard pages (x86, core)
To: Rik van Riel <riel@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 11:02 AM, Rik van Riel <riel@redhat.com> wrote:
> On Tue, 2016-06-21 at 10:16 -0700, Kees Cook wrote:
>> On Tue, Jun 21, 2016 at 2:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >
>> > On Monday, June 20, 2016 4:43:30 PM CEST Andy Lutomirski wrote:
>> > >
>> > >
>> > > On my laptop, this adds about 1.5=C2=B5s of overhead to task creatio=
n,
>> > > which seems to be mainly caused by vmalloc inefficiently
>> > > allocating
>> > > individual pages even when a higher-order page is available on
>> > > the
>> > > freelist.
>> > Would it help to have a fixed virtual address for the stack instead
>> > and map the current stack to that during a task switch, similar to
>> > how we handle fixmap pages?
>> >
>> > That would of course trade the allocation overhead for a task
>> > switch
>> > overhead, which may be better or worse. It would also give
>> > "current"
>> > a constant address, which may give a small performance advantage
>> > but may also introduce a new attack vector unless we randomize it
>> > again.
>> Right: we don't want a fixed address. That makes attacks WAY easier.
>
> Does that imply we might want the per-cpu cache of
> these stacks to be larger than one, in order to
> introduce some more randomness after an attacker
> crashed an ASLRed program looking for ROP gadgets,
> and the next one is spawned? :)

This is the kernel stack, so this only really matters if there's some
attack in which you OOPS but learn the kernel stack address in the
process and then reuse that stack.  So... maybe?

--Andy
