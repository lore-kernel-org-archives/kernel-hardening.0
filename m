MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CA+55aFxeJ-6JB-DeZavyzeAYrcdjM=5tMM5dMxvNgT5WJLfQMQ@mail.gmail.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com> <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
 <CAGXu5j+-AjMKxOYDOpbmJ4X357JRGWViAOmqyqd6bu_w47mffw@mail.gmail.com>
 <20180306080855.phtgl2bzqm5hnthu@gmail.com> <CA+DvKQ+uQD0qyMvwqaRd_sMLBHE5q9pcfOQ+VknBW2==q0NJJA@mail.gmail.com>
 <CA+55aFwgmTaaA8QqMGm+VzRNbpKxDXbq2MtKyayyq8f+=PqWqA@mail.gmail.com>
 <CAKv+Gu_VaO39h8trgsNhU4JEVkdgoFWGoovBdmAL_YsHe7Nq1Q@mail.gmail.com>
 <CA+55aFxkzxhGaK=sp2CqM1YFEE=fL33wC1TR4KKqsRqPGto6yA@mail.gmail.com>
 <CAK8P3a0bWWZbFW5AFag=vRKC=PbCbwaLNPNiyk1ziJk=fTe0nQ@mail.gmail.com>
 <CA+55aFxTdT11pxKL7oscN=2bu8wkiZbZgDfQd_Emqk1Z1Qqb7A@mail.gmail.com>
 <CAK8P3a3BA2BueHOuOiszEzkBtA80QDdo3wgX+62=KXCdi9wScQ@mail.gmail.com> <CA+55aFxeJ-6JB-DeZavyzeAYrcdjM=5tMM5dMxvNgT5WJLfQMQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 6 Mar 2018 23:09:45 +0100
Message-ID: <CAK8P3a12YVBK6rtXwubW-0W3XwEbF+BU21MN1Fx8OrA4-2S7vw@mail.gmail.com>
Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in syscall_trace_enter()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 10:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 6, 2018 at 1:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> Right, there are two separate problems: the missing warnings
>> and the actual uninitialized use. Allocating the stack slots would
>> address both but only at an enormous cost. Assigning a value
>> would still have a cost, as it would prevent certain other optimizations,
>> and it wouldn't help find the missing initializations,
>> but the cost would obviously be much lower.
>
> What possible optimization would it prevent?
>
> I cannot think of a single interesting optimization that would be
> invalidated by a trivial initialization of 0 to a scalar.
>
> Yes, it can obviously generate some extra code for the "pass pointer
> to uninitialized scalar around to be initialized", where it can now
> make that stack slot be initialized to zero - so it can generate extra
> code. But disabling an optimization?
>
> What did you have in mind?

The type of optimization that causes my earlier example

int g(int c)
{
        int i;
        if (c)  /* gcc optimizes out the condition as nothing else sets i */
                i = 1;
        return i;
}

to be simplified to

int g(int c)
{
        return 1;
}

Obviously the specific example is a bug and we'd be better off
with the zero-initialization, but it was clearly an intentional
optimization. The bug report in [1]
suggests that the optimization step that causes the loss of
information here is "sparse conditional constant propagation"
as described in [2].

I have to admit that I understand nearly nothing of that
paper, but my memory from earlier discussions with
gcc folks is that it will merge code paths for uninitialized
variables with the normal case if there is exactly one
initialization, or more generally try to eliminate any code
path that leads to undefined behavior.
By forcing an initialization, I would imagine that this early
dead code elimination fails even for the case that a
later optimization step can prove that an uninitialized
variable use never occurs.

      Arnd

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501
[2] http://www.cs.wustl.edu/~cytron/531Pages/f11/Resources/Papers/cprop.pdf
