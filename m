Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1466533948.2756.56.camel@redhat.com>
References: <cover.1466466093.git.luto@kernel.org> <f7855f9eae0a27f5a03db1291f46fea1cc0a2a3f.1466466093.git.luto@kernel.org>
 <CAG48ez3WGu+03HDBA5daSV+zXGoR+iFHHYxZav0o6JCM9-EPMg@mail.gmail.com>
 <CALCETrWp+7+9j1vMgv5hxvtq3akZZZVdaVDfOLoFwhX+kL=Ntw@mail.gmail.com>
 <CAGXu5jJjihEU0HkSTWJymLZ5y=J03bkBHNgVf9QOSgWz6bf-SQ@mail.gmail.com> <1466533948.2756.56.camel@redhat.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Mon, 11 Jul 2016 20:00:43 +0300
Message-ID: <CAPAsAGzOyOvfiZZArra2JhCeaa7pd9tnva28rD7L8Yx-2BDj-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v3 06/13] fork: Add generic
 vmalloced stack support
To: Rik van Riel <riel@redhat.com>
Cc: kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

2016-06-21 21:32 GMT+03:00 Rik van Riel <riel@redhat.com>:
> On Tue, 2016-06-21 at 10:13 -0700, Kees Cook wrote:
>> On Tue, Jun 21, 2016 at 9:59 AM, Andy Lutomirski <luto@amacapital.net
>> > wrote:
>> >
>> > I'm tempted to explicitly disallow VM_NO_GUARD in the vmalloc
>> > range.
>> > It has no in-tree users for non-fixed addresses right now.
>> What about the lack of pre-range guard page? That seems like a
>> critical feature for this. :)
>
> If VM_NO_GUARD is disallowed, and every vmalloc area has
> a guard area behind it, then every subsequent vmalloc area
> will have a guard page ahead of it.
>
> I think disallowing VM_NO_GUARD will be all that is required.
>

VM_NO_GUARD is a flag of vm_struct. But some vmalloc areas don't have
vm_struct (see vm_map_ram())
and don't have guard pages too. Once, vm_map_ram() had guard pages,
but they were removed in
248ac0e1943a ("mm/vmalloc: remove guard page from between vmap blocks")
due to exhaustion of vmalloc space on 32-bits. I guess we can
resurrect guard page on 64bits without any problems.

AFAICS per-cpu vmap blocks also don't have guard pages. pcpu vmaps
have vm_struct *without* VM_NO_GUARD, but
don't actually have the guard pages. It seems to be a harmless bug,
because pcpu vmaps use their own alloc/free paths
(pcp_get_vm_areas()/pcpu_free_vm_areas())
and just don't care about vm->flags content.
Fortunately, pcpu_get_vm_areas() allocates from top of vmalloc, so the
gap between pcpu vmap and regular vmalloc() should be huge.

> The only thing we may want to verify on the architectures that
> we care about is that there is nothing mapped immediately before
> the start of the vmalloc range, otherwise the first vmalloced
> area will not have a guard page below it.
>
> I suspect all the 64 bit architectures are fine in that regard,
> with enormous gaps between kernel memory ranges.
>
> --
> All Rights Reversed.
>
