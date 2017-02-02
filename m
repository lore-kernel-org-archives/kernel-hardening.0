MIME-Version: 1.0
In-Reply-To: <20170202064415.GB5179@localhost.localdomain>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com> <20170202064415.GB5179@localhost.localdomain>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu, 2 Feb 2017 23:51:49 +0530
Message-ID: <CACi5LpNyyc6GPF67EwD9rQ_djyewwh8t5tHperE6Ka70B6g+iw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: Balbir Singh <bsingharora@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Alistair Popple <alistair@popple.id.au>, Anatolij Gustschin <agust@denx.de>, Kees Cook <keescook@chromium.org>, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, Daniel Cashman <dcashman@google.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Balbir,

On Thu, Feb 2, 2017 at 12:14 PM, Balbir Singh <bsingharora@gmail.com> wrote:
> On Thu, Feb 02, 2017 at 11:12:46AM +0530, Bhupesh Sharma wrote:
>> This RFC patchset tries to make the powerpc ASLR elf randomness
>> implementation similar to other ARCHs (like x86).
>>
>> The 1st patch introduces the support of ARCH_MMAP_RND_BITS in powerpc
>> mmap implementation to allow a sane balance between increased randomness
>> in the mmap address of ASLR elfs and increased address space
>> fragmentation.
>>
>
> From what I see we get 28 bits of entropy right for 64k pages
> bits as compared to 14 bits earlier?

That's correct. We can go upto 28-bits of entropy for 64BIT platforms
using 64K pages with the current approach. I see arm64 using > 28 bits
of entropy randomness in some cases, but I think 28-bit MAX entropy is
sensible for 64BIT/64K combination on PPC.

>> The 2nd patch increases the ELF_ET_DYN_BASE value from the current
>> hardcoded value of 0x2000_0000 to something more practical,
>> i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
>> 64-bit platforms which would like to utilize more randomization
>> in the load address of a PIE elf).
>>
>
> This helps PIE executables as such and leaves other not impacted?

It basically affects all shared object files (as noted in [1]).
However as Kees noted in one of his reviews, I think this 2nd patch
might not be needed for all generic ppc platforms.

[1] http://lxr.free-electrons.com/source/arch/powerpc/include/asm/elf.h#L26.

Regards,
Bhupesh
