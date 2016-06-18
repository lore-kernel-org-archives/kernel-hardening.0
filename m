Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160617203045.GB3842@pd.tnic>
References: <cover.1466192946.git.luto@kernel.org> <3336bb02792d56c49d18e2f7a435fd194a4a22e4.1466192946.git.luto@kernel.org>
 <20160617203045.GB3842@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 18 Jun 2016 03:29:01 -0700
Message-ID: <CALCETrW-i8p=w5PTW817kAmfybHUntYkcAjc6sUsFJGcDGdnMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 03/13] x86/cpa: Warn if kernel_unmap_pages_in_pgd is
 used inappropriately
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2016 at 1:30 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jun 17, 2016 at 01:00:39PM -0700, Andy Lutomirski wrote:
>> It's currently only used in the EFI code, which is safe AFAICT.
>
> "It is basically useful for a pagetable hierarchy which is not init_mm."
>
>> Warn if anyone tries to use it on the normal kernel pgd.
>>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>>  arch/x86/mm/pageattr.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>> index 6a8026918bf6..e9b9c5cedbb8 100644
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -1996,6 +1996,9 @@ out:
>>  void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
>>                              unsigned numpages)
>>  {
>> +     /* Unmapping kernel entries from init_mm's pgd is not allowed. */
>> +     WARN_ON(root == init_mm.pgd);
>
> We can also return and not do the unmapping:
>
>         if (WARN_ON(root == init_mm.pgd))
>                 return;

I'll do one better: the only function that calls this function is
unused.  I'll just delete it.

--Andy
