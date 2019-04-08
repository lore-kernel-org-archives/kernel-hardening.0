MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-15-thgarnie@chromium.org>
 <01000168a5b35a86-b79bfe67-191e-43bc-a5c7-0e74eac06195-000000@email.amazonses.com>
 <CAJcbSZGKR7dKVqNEDEO7Qzf7tnNqmL=p1uVKvsUefS=Hs-=iNA@mail.gmail.com>
 <01000168a6e5ab88-0deea73f-387f-4941-bd11-d1c161aac88a-000000@email.amazonses.com>
 <CAJcbSZFvafvNX1pS96jaTBGNJad+NszLwSgKnRQgyT70gUGWqQ@mail.gmail.com>
 <CAJcbSZETNhr=Pv+0daEWUsD2=qnZxT9rbmFaE+y7ag-xKOs89w@mail.gmail.com> <01000169fe18026e-a0951268-516c-4604-a4c3-140f3cbb6f7a-000000@email.amazonses.com>
In-Reply-To: <01000169fe18026e-a0951268-516c-4604-a4c3-140f3cbb6f7a-000000@email.amazonses.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Mon, 8 Apr 2019 11:08:58 -0700
Message-ID: <CAJcbSZFVnJ6qYNsGipf6foa8dtsX_RDykRWK-edP85ySQacsVg@mail.gmail.com>
Subject: Re: [PATCH v6 14/27] x86/percpu: Adapt percpu for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Christopher Lameter <cl@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Cao jin <caoj.fnst@cn.fujitsu.com>, Brijesh Singh <brijesh.singh@amd.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Joerg Roedel <jroedel@suse.de>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 8, 2019 at 10:56 AM Christopher Lameter <cl@linux.com> wrote:
>
> On Mon, 8 Apr 2019, Thomas Garnier wrote:
>
> > > It didn't work originally but I will revisit to see if I missed something.
> >
> > I revisited and couldn't find a way to prevent relocations to the
> > percpu section. Without PIE, you can reference absolute address which
> > was convenient for percpu.
>
> Can you switch PIE off for the percpu section? If not maybe the linker
> needs to have an additional option?

I don't think so or I didn't find any option to do that. Changing the
linker might be a bit too much if we have a software solution which
doesn't impact performance.

>
> Cannot imagine that this is not possible. You neeed to be able to
> reference registers that are in fixed memory locations.
>
>
> > Christopher: Did you have something specific in mind?
>
> I thought that we just leave it as is.

I would like to as well. I will try couple things at the assembly
level instead of the linker and come back to this thread.
