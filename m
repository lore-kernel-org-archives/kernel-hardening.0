Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrXG4tA=YexrdoMcy0xQeN9Oq0eDeUXKjFHCs-1HUMigDg@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <13212319.WrhLzgRA6Z@wuerfel>
 <CAGXu5jJaWxcOKLtXG3r1XWE8NpL=GFSZwmV_UYjjv6q0135ETQ@mail.gmail.com>
 <6248429.A4IJrfgOW3@wuerfel> <CALCETrXG4tA=YexrdoMcy0xQeN9Oq0eDeUXKjFHCs-1HUMigDg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 13:18:38 -0700
Message-ID: <CAGXu5jJKnEdUw3yNjYLif8EXeavOJROd3YdEoS-JtmrQEF5Z-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 12:47 PM, Andy Lutomirski <luto@amacapital.net> wro=
te:
> On Tue, Jun 21, 2016 at 12:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday, June 21, 2016 10:16:21 AM CEST Kees Cook wrote:
>>> On Tue, Jun 21, 2016 at 2:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> > On Monday, June 20, 2016 4:43:30 PM CEST Andy Lutomirski wrote:
>>> >>
>>> >> On my laptop, this adds about 1.5=C2=B5s of overhead to task creatio=
n,
>>> >> which seems to be mainly caused by vmalloc inefficiently allocating
>>> >> individual pages even when a higher-order page is available on the
>>> >> freelist.
>>> >
>>> > Would it help to have a fixed virtual address for the stack instead
>>> > and map the current stack to that during a task switch, similar to
>>> > how we handle fixmap pages?
>>> >
>>> > That would of course trade the allocation overhead for a task switch
>>> > overhead, which may be better or worse. It would also give "current"
>>> > a constant address, which may give a small performance advantage
>>> > but may also introduce a new attack vector unless we randomize it
>>> > again.
>>>
>>> Right: we don't want a fixed address. That makes attacks WAY easier.
>>
>> Do we care about making the address more random then? When I look
>> at /proc/vmallocinfo, I see that allocations are all using
>> consecutive addresses, so if you can figure out the virtual
>> address of the stack for one process that would give you a good
>> chance of guessing the address for the next pid.
>
> Quite possibly.  We should seriously consider at least randomizing the
> *start* of the vmalloc area, at least on 64-bit architectures.

Yup, this is already under way for x86. Thomas Garnier has a series
that he's been working on:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dkaslr/m=
emory

I'd love to see similar for other architectures too.

Thomas just sent me an updated series I'll be putting up for review later t=
oday.

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
