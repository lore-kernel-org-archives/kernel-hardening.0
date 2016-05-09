Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <CAGXu5jJk0MMNP1vvS6oDMMVXLmrSybCf5E_F7q45=c1a=PX8kQ@mail.gmail.com>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
	<1462825332-10505-2-git-send-email-keescook@chromium.org>
	<CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
	<CAGXu5jJk0MMNP1vvS6oDMMVXLmrSybCf5E_F7q45=c1a=PX8kQ@mail.gmail.com>
Date: Mon, 9 May 2016 15:28:33 -0700
Message-ID: <CAE9FiQVMq=Eh9m4BasuthD9-2qXwy32wB8egYsEp1BD6SPrnxw@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 9, 2016 at 3:23 PM, Kees Cook <keescook@chromium.org> wrote:
>> The exact reason to have assigning in functions.
>>
>> pgt_data address could be changed during kernel relocation.
>> so can not assigned during compiling time.
>
> Ah-ha, that explains why I had to keep it on the stack. Thanks for the
> clarification!

My fault, I should put that comment in the code at first place.

Thanks

Yinghai
