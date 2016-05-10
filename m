Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 May 2016 13:21:57 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160510112157.GB28520@pd.tnic>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
 <1462825332-10505-2-git-send-email-keescook@chromium.org>
 <CAE9FiQVQSjtCFQFfP6S1V8wXR0SGwt5hkq_zw9v0NGCCkEx_+Q@mail.gmail.com>
 <CAGXu5jJk0MMNP1vvS6oDMMVXLmrSybCf5E_F7q45=c1a=PX8kQ@mail.gmail.com>
 <CAE9FiQVMq=Eh9m4BasuthD9-2qXwy32wB8egYsEp1BD6SPrnxw@mail.gmail.com>
 <20160510055853.GA2293@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160510055853.GA2293@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7 1/9] x86/KASLR: Initialize mapping_info every time
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, Lasse Collin <lasse.collin@tukaani.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 10, 2016 at 07:58:54AM +0200, Ingo Molnar wrote:
> Ok, could you guys please update the code and the changelog as well,
> and also rename that horribly named prepare_level4() function?

Oh, and while at it, call that new function at the beginning of
choose_random_location() before the first call to add_identity_map()
through mem_avoid_init() and make the code flow even clearer this way
instead of doing funky checks like

        if (!level4p)
                prepare_level4();

Thanks.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
