Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 10 May 2016 07:58:54 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160510055853.GA2293@gmail.com>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
 <1462825332-10505-2-git-send-email-keescook@chromium.org>
 <CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
 <CAGXu5jJk0MMNP1vvS6oDMMVXLmrSybCf5E_F7q45=c1a=PX8kQ@mail.gmail.com>
 <CAE9FiQVMq=Eh9m4BasuthD9-2qXwy32wB8egYsEp1BD6SPrnxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVMq=Eh9m4BasuthD9-2qXwy32wB8egYsEp1BD6SPrnxw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, May 9, 2016 at 3:23 PM, Kees Cook <keescook@chromium.org> wrote:
> >> The exact reason to have assigning in functions.
> >>
> >> pgt_data address could be changed during kernel relocation.
> >> so can not assigned during compiling time.
> >
> > Ah-ha, that explains why I had to keep it on the stack. Thanks for the
> > clarification!
> 
> My fault, I should put that comment in the code at first place.

Ok, could you guys please update the code and the changelog as well, and also 
rename that horribly named prepare_level4() function?

Also, since this code is multi-author, it would be nice to add explicit copyright 
notices to the new arch/x86/boot/compressed/pagetable.c file, it was originally 
written by you, then modified by Kees. Something like:

/*
 * Copyright (C) 2015-2016  Yinghai Lu
 * Copyright (C)      2016  Kees Cook
 */

Thanks,

	Ingo
