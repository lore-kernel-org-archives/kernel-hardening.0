Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160415081223.GF30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
	<1460672954-32567-6-git-send-email-keescook@chromium.org>
	<20160415081223.GF30715@gmail.com>
Date: Fri, 15 Apr 2016 12:14:22 -0700
Message-ID: <CAGXu5jJwiX2z7tYitmMCS-KdRy4+N9VvVc1-Lf+qZLijnxiFQQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 05/21] x86, boot: Calculate decompression size during
 boot not build
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 1:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> Currently z_extract_offset is calculated in boot/compressed/mkpiggy.c.
>
> What is the high level meaning of z_extract_offset? I cannot tell without reading
> the code - and the point of changelogs is for them to be readable without having
> to read the code.

I'll clarify it in the changelog. (FWIW, it's the offset into the
extraction buffer where it's safe to put the data-to-be-extracted).

> The rest of the changelog is pretty good.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
