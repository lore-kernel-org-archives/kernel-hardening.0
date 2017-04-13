MIME-Version: 1.0
In-Reply-To: <03284709-498c-1e52-40f0-b19d20e56b8e@linux.vnet.ibm.com>
References: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
 <87shlcq0es.fsf@skywalker.in.ibm.com> <CACi5LpP5jC7obg57zj2jZUQCoh_Et2rbdQMtthXy3Ksb2Qc4ow@mail.gmail.com>
 <03284709-498c-1e52-40f0-b19d20e56b8e@linux.vnet.ibm.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu, 13 Apr 2017 13:16:47 +0530
Message-ID: <CACi5LpNpASkeVeZdOuN9GPcBKBb3EmM8uKWmceLQ5s=gXw87vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] powerpc: mm: support ARCH_MMAP_RND_BITS
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alistair Popple <alistair@popple.id.au>, Anatolij Gustschin <agust@denx.de>, Kees Cook <keescook@chromium.org>, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, Daniel Cashman <dcashman@google.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 13, 2017 at 12:28 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
>
> On Thursday 13 April 2017 12:22 PM, Bhupesh Sharma wrote:
>>
>> Hi Aneesh,
>>
>> On Thu, Apr 13, 2017 at 12:06 PM, Aneesh Kumar K.V
>> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>>
>>> Bhupesh Sharma <bhsharma@redhat.com> writes:
>>>
>>>> powerpc arch_mmap_rnd() currently uses hard-coded values -
>>>> (23-PAGE_SHIFT) for
>>>> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
>>>> for the mmap base address for a ASLR ELF.
>>>>
>>>> This patch makes sure that powerpc mmap arch_mmap_rnd() implementation
>>>> is similar to other ARCHs (like x86, arm64) and uses mmap_rnd_bits
>>>> and helpers to generate the mmap address randomization.
>>>>
>>>> The maximum and minimum randomization range values represent
>>>> a compromise between increased ASLR effectiveness and avoiding
>>>> address-space fragmentation.
>>>>
>>>> Using the Kconfig option and suitable /proc tunable, platform
>>>> developers may choose where to place this compromise.
>>>>
>>>> Also this patch keeps the default values as new minimums.
>>>>
>>>> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>> * Changes since v2:
>>>> v2 can be seen here (https://patchwork.kernel.org/patch/9551509/)
>>>>     - Changed a few minimum and maximum randomization ranges as per
>>>> Michael's suggestion.
>>>>     - Corrected Kees's email address in the Reviewed-by line.
>>>>     - Added further comments in kconfig to explain how the address
>>>> ranges were worked out.
>>>>
>>>> * Changes since v1:
>>>> v1 can be seen here
>>>> (https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-February/153594.html)
>>>>     - No functional change in this patch.
>>>>     - Dropped PATCH 2/2 from v1 as recommended by Kees Cook.
>>>>
>>>>  arch/powerpc/Kconfig   | 44
>>>> ++++++++++++++++++++++++++++++++++++++++++++
>>>>  arch/powerpc/mm/mmap.c |  7 ++++---
>>>>  2 files changed, 48 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>>>> index 97a8bc8..84aae67 100644
>>>> --- a/arch/powerpc/Kconfig
>>>> +++ b/arch/powerpc/Kconfig
>>>> @@ -22,6 +22,48 @@ config MMU
>>>>       bool
>>>>       default y
>>>>
>>>> +# min bits determined by the following formula:
>>>> +# VA_BITS - PAGE_SHIFT - CONSTANT
>>>> +# where,
>>>> +#    VA_BITS = 46 bits for 64BIT and 4GB - 1 Page = 31 bits for 32BIT
>>>
>>>
>>>
>>> Where did we derive that 46 bits from ? is that based on TASK_SIZE ?
>>
>>
>> Yes. It was derived from TASK_SIZE :
>>
>> http://lxr.free-electrons.com/source/arch/powerpc/include/asm/processor.h#L105
>>
>
> That is getting update to 128TB by default and conditionally to 512TB

Can't find the relevant patch in linus's master branch.
Please share the appropriate patch/discussion link.

Regards,
Bhupesh
