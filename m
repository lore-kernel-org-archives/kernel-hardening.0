Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAG48ez3WGu+03HDBA5daSV+zXGoR+iFHHYxZav0o6JCM9-EPMg@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <f7855f9eae0a27f5a03db1291f46fea1cc0a2a3f.1466466093.git.luto@kernel.org>
 <CAG48ez3WGu+03HDBA5daSV+zXGoR+iFHHYxZav0o6JCM9-EPMg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Jun 2016 09:59:49 -0700
Message-ID: <CALCETrWp+7+9j1vMgv5hxvtq3akZZZVdaVDfOLoFwhX+kL=Ntw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 06/13] fork: Add generic vmalloced stack support
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 12:30 AM, Jann Horn <jannh@google.com> wrote:
> On Tue, Jun 21, 2016 at 1:43 AM, Andy Lutomirski <luto@kernel.org> wrote:
>> If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
>> vmalloc_node.
> [...]
>>  static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
>>                                                   int node)
>>  {
>> +#ifdef CONFIG_VMAP_STACK
>> +       struct thread_info *ti = __vmalloc_node_range(
>> +               THREAD_SIZE, THREAD_SIZE, VMALLOC_START, VMALLOC_END,
>> +               THREADINFO_GFP | __GFP_HIGHMEM, PAGE_KERNEL,
>> +               0, node, __builtin_return_address(0));
>> +
>
> After spender gave some hints on IRC about the guard pages not working
> reliably, I decided to have a closer look at this. As far as I can
> tell, the idea is that __vmalloc_node_range() automatically adds guard
> pages unless the VM_NO_GUARD flag is specified. However, those guard
> pages are *behind* allocations, not in front of them, while a stack
> guard primarily needs to be in front of the allocation. This wouldn't
> matter if all allocations in the vmalloc area had guard pages behind
> them, but if someone first does some data allocation with VM_NO_GUARD
> and then a stack allocation directly behind that, there won't be a
> guard between the data allocation and the stack allocation.

I'm tempted to explicitly disallow VM_NO_GUARD in the vmalloc range.
It has no in-tree users for non-fixed addresses right now.
