Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160415174231.7425bc7a@tukaani.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
	<1460672954-32567-14-git-send-email-keescook@chromium.org>
	<20160415174231.7425bc7a@tukaani.org>
Date: Fri, 15 Apr 2016 12:28:05 -0700
Message-ID: <CAGXu5jJ_Bzv=YQ51KjQOUfs0-14CxR1J1=SaF86Wnx0QZBp7Mg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 13/21] x86, boot: Report overlap failures in memcpy
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 7:42 AM, Lasse Collin <lasse.collin@tukaani.org> wrote:
> On 2016-04-14 Kees Cook wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> parse_elf is using a local memcpy to move sections to their final
>> running position. However, this memcpy only supports non-overlapping
>> arguments (or dest < src).
>
> The same copy of memcpy is used by the decompressors too.
>
>> To avoid future hard-to-debug surprises, this adds checking in memcpy
>> to detect the unhandled condition (which should not be happening
>> currently).
>
> It's already a minor surprise that memcpy is expected to work for
> overlapping buffers at all. It could be good to have a comment about
> it because "scroll" and parse_elf seem to rely on it.
>
> On the other hand, the new code and error message take quite a few bytes
> of space, so a complete memmove can be smaller:
>
> void *memmove(void *dest, const void *src, size_t n)
> {
>         unsigned char *d = dest;
>         const unsigned char *s = src;
>
>         if (d <= s || d - s >= n)
>                 return __memcpy(dest, src, n);
>
>         while (n-- > 0)
>                 d[n] = s[n];
>
>         return dest;
> }
>
> Note that memmove is needed by lib/decompress_unxz.c. It contains its
> own small version inside a "#ifndef memmove" block. That #ifndef should
> be taken into account when adding a memmove symbol. Changing
> decompress_unxz.c is fine but then one needs to think about other
> archs too.

Awesome, thanks! I'd much prefer to fully fix this instead of just
throwing a warning. I'll get this added.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
