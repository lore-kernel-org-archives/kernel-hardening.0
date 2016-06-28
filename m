Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160628184810.GA2855@pd.tnic>
References: <cover.1466974736.git.luto@kernel.org> <edf5c9e2572b2ea6e1a7f7b3f1c5e9968907b7fb.1466974736.git.luto@kernel.org>
 <20160628184810.GA2855@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Jun 2016 12:07:38 -0700
Message-ID: <CALCETrV5aNcfdkNwJna-sOm84zzFccTBqv2KBn-p16U63rYUcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 04/29] x86/cpa: In populate_pgd, don't set the pgd
 entry until it's populated
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2016 at 11:48 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Jun 26, 2016 at 02:55:26PM -0700, Andy Lutomirski wrote:
>> This avoids pointless races in which another CPU or task might see a
>> partially populated global pgd entry.  These races should normally
>> be harmless, but, if another CPU propagates the entry via
>> vmalloc_fault and then populate_pgd fails (due to memory allocation
>> failure, for example), this prevents a use-after-free of the pgd
>> entry.
>>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  arch/x86/mm/pageattr.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>> index 7a1f7bbf4105..6a8026918bf6 100644
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -1113,7 +1113,9 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
>>
>>       ret = populate_pud(cpa, addr, pgd_entry, pgprot);
>>       if (ret < 0) {
>> -             unmap_pgd_range(cpa->pgd, addr,
>> +             if (pud)
>> +                     free_page((unsigned long)pud);
>> +             unmap_pud_range(pgd_entry, addr,
>>                               addr + (cpa->numpages << PAGE_SHIFT));
>>               return ret;
>>       }
>> --
>
> So something's amiss here. Subject says:
>
> "x86/cpa: In populate_pgd, don't set the pgd entry until it's populated"
>
> but you haven't moved
>
>         set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
>
> after populate_pud() succeeds... Which is a good catch but your patch
> should do it too. :-)

Good catch.  I'll fix this in the next version.

--Andy
