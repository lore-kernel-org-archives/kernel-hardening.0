Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160511062442.GA24803@gmail.com>
References: <1462900755-20005-1-git-send-email-keescook@chromium.org>
	<1462900755-20005-2-git-send-email-keescook@chromium.org>
	<20160511062442.GA24803@gmail.com>
Date: Wed, 11 May 2016 08:23:45 -0700
Message-ID: <CAGXu5j+4N0YSkEb54k6Wj6oZW8OKTwS12LtajTnerw03knRimw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v8 1/4] x86/KASLR: Clarify identity map interface
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 10, 2016 at 11:24 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> +/*
>> + * Mapping information structure passed to kernel_ident_mapping_init().
>> + * Due to relocation, pointers must be assigned at run time not build time.
>> + */
>> +static struct x86_mapping_info mapping_info = {
>> +     .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> +};
>
>> +void initialize_identity_maps(void)
>>  {
>> +     /* Init mapping_info with run-time function/buffer pointers. */
>> +     mapping_info.alloc_pgt_page = alloc_pgt_page;
>> +     mapping_info.context = &pgt_data;
>
> Could you please outline the precise failure mode? What gets executed when, which
> pointer gets relocated and which not, and exactly when does it pose a problem,
> etc.

It's the issue described at the top of misc.c:

/*
 * WARNING!!
 * This code is compiled with -fPIC and it is relocated dynamically at
 * run time, but no relocation processing is performed. This means that
 * it is not safe to place pointers in static structures.
 */

Should this be repeated in each .c file maybe as a reminder?

If the rest of the patches look good, we could clean this up as a
following patch? What do you think?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
