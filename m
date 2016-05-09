Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
	<1462825332-10505-2-git-send-email-keescook@chromium.org>
	<CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
Date: Mon, 9 May 2016 15:23:34 -0700
Message-ID: <CAGXu5jJk0MMNP1vvS6oDMMVXLmrSybCf5E_F7q45=c1a=PX8kQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 9, 2016 at 3:01 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, May 9, 2016 at 1:22 PM, Kees Cook <keescook@chromium.org> wrote:
>> As it turns out, mapping_info DOES need to be initialized every
>> time. Without this, page tables were not being corrected updated, which
>> could cause reboots when a physical address beyond 2G was chosen.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/x86/boot/compressed/pagetable.c | 16 +++++-----------
>>  1 file changed, 5 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
>> index 3c99051566a9..34b95df14e69 100644
>> --- a/arch/x86/boot/compressed/pagetable.c
>> +++ b/arch/x86/boot/compressed/pagetable.c
>> @@ -90,23 +90,17 @@ static void prepare_level4(void)
>>  }
>>
>>  /*
>> - * Mapping information structure passed to kernel_ident_mapping_init().
>> - * Since this never changes, there's no reason to repeatedly fill it
>> - * in on the stack when calling add_identity_map().
>> - */
>> -static struct x86_mapping_info mapping_info = {
>> -       .alloc_pgt_page = alloc_pgt_page,
>> -       .context        = &pgt_data,
>> -       .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> -};
>> -
>> -/*
>>   * Adds the specified range to what will become the new identity mappings.
>>   * Once all ranges have been added, the new mapping is activated by calling
>>   * finalize_identity_maps() below.
>>   */
>>  void add_identity_map(unsigned long start, unsigned long size)
>>  {
>> +       struct x86_mapping_info mapping_info = {
>> +               .alloc_pgt_page = alloc_pgt_page,
>> +               .context        = &pgt_data,
>> +               .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> +       };
>>         unsigned long end = start + size;
>
> Still should be assigned once, and should be done in
> prepare_level4(). --- by may need different name for that ?
>
> The exact reason to have assigning in functions.
>
> pgt_data address could be changed during kernel relocation.
> so can not assigned during compiling time.

Ah-ha, that explains why I had to keep it on the stack. Thanks for the
clarification!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
