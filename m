MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFx45SM4VxD-V4qLo8=hxqYtGH+qBeB74KekwCkJK7D=xA@mail.gmail.com>
References: <CAGXu5j+4mEyhE6shkxWqY4AVQGcq2U7nzf4j_n2+CdW2t6CzqQ@mail.gmail.com>
 <CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com>
 <CAGXu5jJVSG7ZuftTRGZjgKqetpmxNpeqwxAzhY8BJ4_H-oUw5w@mail.gmail.com>
 <CA+55aFyfW901QRpdmgEsaY8b4+AOPf2SKKVo7mNs2iRUTHND3w@mail.gmail.com>
 <fe00723e-bdd0-3558-a137-da5f4f3d6127@redhat.com> <CA+55aFx45SM4VxD-V4qLo8=hxqYtGH+qBeB74KekwCkJK7D=xA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Mar 2018 09:38:07 -0700
Message-ID: <CA+55aFx+Sue=MLs34j=8-3gf-UB8LmvBhWNFXNA1aUYbUier5A@mail.gmail.com>
Subject: Re: Fully initialized stack usage (was Re: [PATCH RFC v9 4/7]
 x86/entry: Erase kernel stack in syscall_trace_enter())
Content-Type: text/plain; charset="UTF-8"
To: Florian Weimer <fweimer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, P J P <pjp@fedoraproject.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Micay <danielmicay@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 14, 2018 at 9:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The second one results in good code:
>
>         movl    $0, 16(%rsp)
>         movl    $123, 20(%rsp)
>
> which is good and doesn't leave the padding uninitialized

Side note: this obviously implies that your patch already fixes
things, but funnily, it only if the structure didn't have an
initializer.

IOW, with your patch,

        struct a a;

        a = (struct a) ( 1, 2 };

would do the right thing for us because of an odd internal gcc
implementation detail, because that initial definition of 'a' doesn't
have an initializer, so your patch adds an empty one, and gcc seems to
always treat that as "clear the whole stricture". After that, the
structure assignment works fine and leaves the padding zero.

But a plain

        struct a a = { 1, 2 };

doesn't DTRT, and leaves uninitialized bytes to be passed around.

Of course, there might be other special cases that I simply didn't
happen to trigger with my overly stupid example and testing. Maybe
sometimes gcc does structure copies or clearing using the
member-by-member model?

My quick testing seems to indicate that it's _only_ initializers that
cause this, whether they are part of the variable declaration or
afterwards.

              Linus
