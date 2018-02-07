MIME-Version: 1.0
In-Reply-To: <CA+55aFxU_vo+JFBZcvE5EOs2D_QHNXBf4G=-KT=3LeP2zjECHw@mail.gmail.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206192925.qkmghwsbaysr4iv2@hermes.olymp> <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
 <CA+55aFxYHX3=HN4P5M0ziSJ08WfjccyhE2T7epS-EC6ZJ6LyjQ@mail.gmail.com>
 <CAPcyv4i5oORdk-Fzypxw_+gCLUa8f=w1e_n0=47P7uHR-jT6GQ@mail.gmail.com>
 <CA+55aFzZVL=WVuhJAQDazj59jwnmhUrRRwNgzXS+c-q5yva0iw@mail.gmail.com>
 <CALCETrXV3rHb7Z8iaoieAJ5hRY0+UT7eTknxe4-FiOoke9XoGg@mail.gmail.com>
 <CA+55aFy2-OMMCatHTXL7wfP7H=4CEKv4Y_pRvfeEOCwxriDP4Q@mail.gmail.com>
 <CAPcyv4hELJQMEBQ_gi+_bh4D=7h47ypzK++XTdQjhDGnOs2uRg@mail.gmail.com> <CA+55aFxU_vo+JFBZcvE5EOs2D_QHNXBf4G=-KT=3LeP2zjECHw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Feb 2018 16:33:04 -0800
Message-ID: <CAPcyv4gE6qgncGPWWu1aWxbK6fO-tvpDEpE+zkZPfeL+EJAr1w@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Luis Henriques <lhenriques@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 6, 2018 at 2:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Feb 6, 2018 at 1:37 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> At that point we're basically just back to the array_ptr() version
>> that returned a sanitized pointer to an array element.
>
> .. that one does an extra unnecessary 'andq' instead of the duplicated
> cmp.  But at least it avoids comparing that 32-bit integer twice, so
> it's probably slightly smaller.
>
> (And your code generation is without the "r" -> "ir" fix for the size argument)
>
> Probably doesn't matter. But a "asm goto" would give you at least
> potentially optimal code.
>

Should we go with array_element_nospec() in the meantime? So we're not
depending on jump labels? With the constraint fix and killing that
superfluous AND the assembly is now:

     e26:       48 81 fd 4d 01 00 00    cmp    $0x14d,%rbp
     e2d:       48 19 d2                sbb    %rdx,%rdx
                        NR_syscalls);
        if (likely(call))
     e30:       48 21 d0                and    %rdx,%rax
     e33:       74 1e                   je     e53 <do_syscall_64+0x73>
                regs->ax = (*call)(regs->di, regs->si, regs->dx,
     e35:       48 8b 4b 38             mov    0x38(%rbx),%rcx
     e39:       48 8b 53 60             mov    0x60(%rbx),%rdx
     e3d:       48 8b 73 68             mov    0x68(%rbx),%rsi
     e41:       48 8b 7b 70             mov    0x70(%rbx),%rdi
     e45:       4c 8b 4b 40             mov    0x40(%rbx),%r9
     e49:       4c 8b 43 48             mov    0x48(%rbx),%r8
     e4d:       ff 10                   callq  *(%rax)
     e4f:       48 89 43 50             mov    %rax,0x50(%rbx)
     e53:       65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
