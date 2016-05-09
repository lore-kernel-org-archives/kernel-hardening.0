Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <CAE9FiQW6JokFqma2u-HgncN0XLBxtBHL3OqcccA94B3XPvXAzw@mail.gmail.com>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
	<1462825332-10505-2-git-send-email-keescook@chromium.org>
	<CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
	<CAE9FiQW6JokFqma2u-HgncN0XLBxtBHL3OqcccA94B3XPvXAzw@mail.gmail.com>
Date: Mon, 9 May 2016 15:27:21 -0700
Message-ID: <CAE9FiQXUDYK93Ob39Gg62yVXDcbwViP05oyTSQC3p_Z0RLK0Cg@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 9, 2016 at 3:23 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, May 9, 2016 at 3:01 PM, Yinghai Lu <yinghai@kernel.org> wrote:

>> Still should be assigned once, and should be done in
>> prepare_level4(). --- by may need different name for that ?
>>
>> The exact reason to have assigning in functions.
>>
>> pgt_data address could be changed during kernel relocation.
>> so can not assigned during compiling time.
>
> Something like:
>
> -/*
> - * Mapping information structure passed to kernel_ident_mapping_init().
> - * Since this never changes, there's no reason to repeatedly fill it
> - * in on the stack when calling add_identity_map().
> - */
> -static struct x86_mapping_info mapping_info = {
> -       .alloc_pgt_page = alloc_pgt_page,
> -       .context        = &pgt_data,
> -       .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
> -};
> +static struct x86_mapping_info mapping_info;
>
>  /*
>   * Adds the specified range to what will become the new identity mappings.
> @@ -110,8 +101,14 @@ void add_identity_map(unsigned long start,
> unsigned long size)
>         unsigned long end = start + size;
>
>         /* Make sure we have a top level page table ready to use. */
> -       if (!level4p)
> +       if (!level4p) {
> +               /* need to set once during run time */
> +               mapping_info.alloc_pgt_page     = alloc_pgt_page;
> +               mapping_info.context    = &pgt_data;
> +               mapping_info.pmd_flag   = __PAGE_KERNEL_LARGE_EXEC;
> +
>                 prepare_level4();
> +       }
>
>         /* Align boundary to 2M. */
>         start = round_down(start, PMD_SIZE);

It would be better if Ingo could fold the change to

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/patch/?id=3a94707d7a7bb1eb82acae5fbc035247dd1ba8a5
x86/KASLR: Build identity mappings on demand

As it happens to the last commit in tip/x86/boot.

Thanks

Yinghai
